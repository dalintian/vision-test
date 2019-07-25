<template>
  <div class="container">
    <div :class="['info',{'hidden':blackScreen}]">
      <div :class="['info-input',{'hidden':this.showHint}]">
        <div class="name">
          <span>姓名</span>
          <input type="text" v-model="name" />
        </div>
        <div class="age">
          <span>年龄</span>
          <input type="text" v-model="age"/>
        </div>
        <div class="begin">
          <div class="button" @click="beginTest">开始测试</div>
        </div>
      </div>
      <div :class="['hint',{'hidden': !showHint}]">
        即将进入视觉适应阶段，此阶段为30s黑屏
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      name: '',
      age: '',
      showHint: false,
      blackScreen: false
    }
  },
  mounted () {
    this.showHint = false
    this.blackScreen = false
  },
  methods: {
    beginTest () {
      if (this.name && this.age) {
        this.showHint = true
        setTimeout(() => {
          this.blackScreen = true
        }, 3000)
        setTimeout(() => {
          this.$router.push({path: '/image', query: {name: this.name, age: this.age}})
        }, 30000)
      } else {
        alert('姓名和年龄不能为空')
      }
    }
  }
}
</script>
<style lang="less" scoped>
.container {
  width: 100vw;
  height: 100vh;
  background-color: black;
  display: flex;
  justify-content: center;
  align-items: center;
  .info {
    padding: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 10px;
    background-color: rgba(244,239,225);
    color:#df6426;
    &.hidden {
      display: none;
    }
    .info-input {
      &.hidden {
        display: none;
      }
      .name {
        margin-bottom: 10px;
        font-weight: bold;
      }
      .age {
        font-weight: bold;
        margin-bottom: 10px;
      }
      .begin {
        display: flex;
        justify-content: center;
        .button {
          padding: 5px;
          text-align: center;
          width: 80px;
          color: #ffffff;
          background-color: #df6426;
          border-radius: 4px;
        }
      }
    }
  }
  .hint {
    color: #df6426;
    &.hidden {
      display: none;
    }
  }
}
input {
  background-color: rgba(245,230,218);
  border: 1px solid rgba(232,200,178);
  padding: 5px;
  border-radius: 2px;
  margin-left: 10px;
  color: #a0806b;
}
</style>
