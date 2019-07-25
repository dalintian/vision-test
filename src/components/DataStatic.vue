<template>
  <div class="container">
    <b-table
      :data="experimentDataList"
      paginated
      per-page="15"
      detail-key="id"
    >
      <template slot-scope="props">
        <b-table-column field="id" label="ID" width="40" numeric>
          {{ props.row.id }}
        </b-table-column>
        <b-table-column label="姓名" >
          {{ props.row.username }}
        </b-table-column>
        <b-table-column field="age" label="年龄" sortable>
          {{ props.row.age }}
        </b-table-column>

        <b-table-column  label="图片名称" >
          {{ props.row.pic}}
        </b-table-column>

        <b-table-column label="用户评价">
          <span :class="['tag',styleTypeOfComment(props.row.response)]">
            {{ typeOfComment(props.row.response) }}
          </span>
        </b-table-column>
        <b-table-column label="图片路径" centered>
          <a target="_blank" :href="props.row.url">{{ props.row.url }}</a>
        </b-table-column>
      </template>
    </b-table>
    <div class="downloadData">
      <a class="button is-link" @click="downExcel">
        下载实验数据
      </a>
      <a class="button is-danger" @click="deleteData">
        删除实验数据
      </a>
    </div>
  </div>
</template>
<script>
import { toExcel } from '../util/file'

export default {
  data () {
    return {
      experimentDataList: []
    }
  },
  mounted () {
    this.getExperimentData()
  },
  methods: {
    // 获取后台数据
    getExperimentData () {
      let self = this
      axios.get('http://120.79.147.66:8081/survey/results').then(function (response) {
        self.experimentDataList = response.data
        console.log(self.experimentDataList)
      }).catch(function (error) {
        console.log(error)
      })
    },
    // 评价转换
    typeOfComment (response) {
      switch (response) {
        case 1:
          return '非常喜欢'
        case 2:
          return '喜欢'
        case 3:
          return '有点喜欢'
        case 4:
          return '有点不喜欢'
        case 5:
          return '不喜欢'
        case 6:
          return '非常不喜欢'
        default:
          return '异常数据'
      }
    },
    styleTypeOfComment (response) {
      if (response === 1 || response === 2) {
        return 'is-success'
      } else if (response === 3 || response === 4) {
        return 'is-warning'
      } else if (response === 5 || response === 6) {
        return 'is-danger'
      }
    },
    // 将数据导为excel
    downExcel () {
      const th = ['ID', '姓名', '年龄', '图片名称', '用户评价', '图片路径']
      const filterVal = ['id', 'username', 'age', 'pic', 'response', 'url']
      const data = this.experimentDataList.map(v => filterVal.map(k => v[k]))
      console.log(data)
      const [fileName, fileType, sheetName] = ['测试数据', 'xlsx', '测试页']
      toExcel({th, data, fileName, fileType, sheetName})
    },
    //删除全部数据
    deleteData() {
      let self = this;
      this.$dialog.confirm({
          title: '删除实验数据',
          message: '确定要<b>删除</b>所有实验数据？删除前请确保实验数据已经下载，删除操作不可恢复',
          confirmText: '确认删除',
          type: 'is-danger',
          hasIcon: true,
          onConfirm: () => {
           axios.post('http://120.79.147.66:8081/survey/clearall').then(function (response) {
              console.log(response.data);
              self.getExperimentData();
            }).catch(function (error) {
              self.$toast.open({
                message: '删除失败',
                type: 'is-danger'
              })
            })       
          }
      })
    }
  }
}
</script>
<style lang="less" scoped>
.downloadData {
  display: flex;
  justify-content: space-between;
  a {
    margin-left: 30px;
    margin-right: 30px;
  }
}
</style>
