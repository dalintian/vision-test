<template>
  <div class="container" :style="`background-image: url('${this.imageList[currentIndex].url}')`">
  <!-- <div class="container" :style="`background-image: url('http://pv707742q.bkt.clouddn.com/BK_F1.png')`"> -->
    <!--<img class="background-image" :src="this.imageList[this.currentIndex]" />-->
    <div class="transparent-float">
      <div class="columns first">
        <div class="rows first" @click="rankImageLevel(1)"></div>
      </div>
      <div class="columns second">
        <div class="rows first" @click="rankImageLevel(2)"></div>
      </div>
    </div>
    <!--当前选择-->
    <div :class="['hint']">
      <div class="">
        {{this.currentIndex + 1}}
      </div>
    </div>
    <!-- 黑屏 -->
    <div :class="['blackscreen',{'hidden': !this.isBlack}]">
    </div>
    <!--上一张-->
    <div class="lastImage" @click="lastImage">
      <!-- hidden: 为true的时候隐藏按钮 -->
      <a :class="['button',{'hidden': lasthideHint || this.isFirst || this.isBlack }]">上一张</a>
    </div>
    <!--下一张-->
    <div class="nextImage" @click="nextImage">
      <a :class="['button',{'hidden': nexthideHint || this.isLast || this.isBlack }]">下一张</a>
    </div>
    <!--提交-->
    <div class="nextImage" @click="submitResult">
      <a :class="['button',{'hidden': hideHint || !this.isLast}]">提交结果</a>
    </div>
    <!--结束框-->
    <div :class="['ending',{'hidden': this.hideEnd}]">
      谢谢您的参与！
    </div>
    <b-loading :is-full-page="true" :active.sync="isLoading" :can-cancel="false"></b-loading>
  </div>
</template>
<script>
import { IMAGE_LIST } from '../data/imageList'
export default {
  name: 'HelloWorld',
  data () {
    return {
      hideHint: true,
      lasthideHint: false,
      nexthideHint: true,
      userComment: '',
      List: IMAGE_LIST,
      currentIndex: 1,
      isFirst: true,
      isLast: false,
      hideEnd: true,
      userCommentList: [],
      imageList:IMAGE_LIST,
      randomList:[],
      response: '',
      isLoading: false,
      submitted: false,
      raceimage:[],
      isBlack: false,
    }
  },
  mounted () {
    // 初始化数据
    this.currentIndex = 0
    this.isFirst = true
    this.isLast = false
    // this.hideEnd = true
    // 随机打乱数组
    let seq = [];
    for(let i = 0; i < 10; i++) seq[i] = i;
    seq = seq.sort((a, b) => {
      return Math.random() > (0.5) ? -1 : 1
      })
    for (let race = 0; race < 10; race++){
      this.raceimage = this.List.slice(60 * seq[race], 60 * seq[race] + 60)
      this.randomList = this.randomList.concat(this.raceimage.sort((a, b) => {
      return Math.random() > (0.5) ? -1 : 1
      }))
    }
    this.imageList = this.randomList
  },
  methods: {
    rankImageLevel (number) {
      let userComment = number;
      // switch (number) {
      //   case 1:
      //     userComment = '非常喜欢'
      //     break
      //   case 2:
      //     userComment = '喜欢'
      //     break
      //   case 3:
      //     userComment = '有点喜欢'
      //     break
      //   case 4:
      //     userComment = '有点不喜欢'
      //     break
      //   case 5:
      //     userComment = '不喜欢'
      //     break
      //   case 6:
      //     userComment = '非常不喜欢'
      //     break
      // }
      //this.hideHint = false;
      this.userComment = userComment;
      this.response = number
      this.nextImage()
    },
    nextImage () {
      let userComments = this.userCommentList
      userComments.push(this.response)
      this.userCommentList = userComments
      let length = this.imageList.length
      if (this.currentIndex < length - 1) {
        this.currentIndex++
      }
      if (this.currentIndex % 60 == 0){
        this.isBlack = true
        setTimeout(() => {
          this.isBlack = false
        }, 20000)
      }
      this.isLast = this.currentIndex === length - 1
      this.isFirst = this.currentIndex === 0
      console.log(this.userCommentList)      
      //this.hideHint = true
    },
    lastImage () {
      let userComments = this.userCommentList
      userComments.splice(-1,1)
      this.userCommentList = userComments
      if (this.currentIndex > 0) {
        this.currentIndex--
      }
      this.isFirst = this.currentIndex === 0
      this.isLast = this.currentIndex === length - 1
      console.log(this.userCommentList)
      //this.hideHint = true
    },
    submitResult () {
      if(this.isLoading){
        return;
      }
      if(this.submitted){
        this.$toast.open({
          message: '数据已经提交成功，请勿重复提交',
          type: 'is-danger'
        })
        return ;
      }
      //上传实验数据
      this.isLoading = true;
      let userComments = this.userCommentList
      let self = this;
      userComments.push(this.response)
      this.userCommentList = userComments
      // this.hideEnd = false

      let picList = this.imageList
      for (let i = 0; i < picList.length; i++) {
        picList[i].response = userComments[i]
        picList[i].name = this.$route.query.name
        picList[i].age = this.$route.query.age
      }
      console.log(picList)

      //分割实验数据
      let length = picList.length;
      let perListLength = length / 3;
      let picList1 = picList.slice(0,perListLength);
      let picList2 = picList.slice(perListLength,perListLength*2);
      let picList3 = picList.slice(perListLength*2);

      let promise1 = axios.post('http://120.79.147.66:8081/survey/submit',{
              data: picList1
          });
      let promise2 = axios.post('http://120.79.147.66:8081/survey/submit',{
              data: picList2
          });
      let promise3 = axios.post('http://120.79.147.66:8081/survey/submit',{
              data: picList3
          });
      Promise.all([promise1,promise2,promise3]).then((res) => {
          self.isLoading = false;
          self.hideEnd = false;
          self.submitted = true;
          // this.$toast.open({
          //     message: '提交成功'
          // })
      }).catch((e) => {
          self.isLoading =false;
          self.$toast.open({
              message: e || '服务器错误',
              type: 'is-danger'
          })
      })
      // axios.post('http://120.79.147.66:8081/survey/submit', {
      //   data: picList
      // }).then(function (response) {
      //   console.log(response)
      //   self.isLoading = false;
      //   self.hideEnd = false;
      // }).catch(function (error) {
      //   self.isLoading = false;
      //   self.$toast.open({
      //     messgae: error.messgae || '服务器未知错误,请稍后重新提交',
      //     type: 'is-danger',
      //   })
      // })
    }
  }
}
</script>
<style lang="less" scoped>
.container {
  width: 100vw;
  height: 100vh;
  background-color: black;
  background-image: url("https://wx4.sinaimg.cn/mw690/007xZLPUly1fyzc5f36mbj30k00dcgmy.jpg");
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  /*background-size: 100% 100%;*/
  .background-image {
    height: 100vh;
    width: 100vw;
  }
  .transparent-float {
    position: absolute;
    top: 0;
    left: 0;
    height: 100vh;
    width: 100vw;
    background-color: transparent;
    display: flex;
    .columns {
      flex: 1;
      background-color:transparent;
      display: flex;
      flex-direction: column;
      .rows {
        flex: 1;
        background-color: transparent;
      }
    }
  }
  .blackscreen {
  position: absolute;
  height: 100vh;
  width: 100vw;
  background-color: black;
    &.hidden {
      display: none;
    }
  }
  .hint {
    position: absolute;
    top: 20px;
    left: 20px;
    border-radius: 4px;
    padding: 10px;
    background: rgba(255,255,255,0.8);
    /*transition-property: all;*/
    /*transition-duration: 1s;*/
    opacity: 1;
    visibility: visible;
    /*transition: all 0.8s linear;*/
    font-weight: bold;

    &.hidden {
      opacity: 0;
      visibility: hidden;
    }
    span {
      font-weight: bold;
      color: brown;
    }
  }
  .lastImage {
    position: absolute;
    left: 10px;
    bottom: 20px;
  }
  .nextImage {
    position: absolute;
    right: 10px;
    bottom: 20px;
  }
}
.button {
  background-color: rgba(255,255,255,0.8);
  padding: 10px;
  opacity: 1;
  visibility: visible;
  /*transition: all 0.8s linear;*/
  &.hidden {
    display: none;
  }
}
.ending {
  position: absolute;
  height: 100vh;
  width: 100vw;
  background-color: rgba(255,255,255,0.8);
  z-index: 99;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 1.5rem;
  font-weight: bold;
  color: brown;
  &.hidden {
    display: none;
  }
}
</style>
