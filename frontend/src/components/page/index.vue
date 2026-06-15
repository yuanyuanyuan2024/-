<template>
  <div>
    <app-head></app-head>
    <app-body>
      <div style="min-height: 85vh;">
        <!-- 页面标题和介绍 -->
        <div class="page-header">
          <div class="header-content">
            <h1 class="page-title">校园二手书闲置<span class="highlight">交易市场</span></h1>
            <p class="page-description">发现校园里的商机，让闲置书籍焕发新生</p>
            <div class="header-decoration">
              <div class="decoration-circle circle-1"></div>
              <div class="decoration-circle circle-2"></div>
              <div class="decoration-circle circle-3"></div>
            </div>
          </div>
        </div>

        <!-- 分类标签 -->
        <div class="category-tabs">
          <el-tabs v-model="labelName" @tab-click="handleClick" class="custom-tabs">
            <el-tab-pane label="全部" name="0">
              <i class="el-icon-s-grid tab-icon"></i> 全部
            </el-tab-pane>
            <el-tab-pane label="软件工程" name="1">
              <i class="el-icon-mobile-phone tab-icon"></i> 软件工程
            </el-tab-pane>
            <el-tab-pane label="外语系" name="2">
              <i class="el-icon-toilet-paper tab-icon"></i> 外语系
            </el-tab-pane>
            <el-tab-pane label="动画" name="3">
              <i class="el-icon-basketball tab-icon"></i> 动画
            </el-tab-pane>
            <el-tab-pane label="电子信息" name="4">
              <i class="el-icon-notebook-2 tab-icon"></i> 电子信息
            </el-tab-pane>
            <el-tab-pane label="公告展示" name="5">
              <i class="el-icon-bell tab-icon"></i> 公告展示
            </el-tab-pane>
          </el-tabs>
        </div>

        <!-- 商品卡片列表 -->
        <div class="items-container">
          <el-row :gutter="24">
            <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="(idle, index) in idleList" :key="index">
              <div class="item-card" @click="toDetails(idle)">
                <div class="item-image-container">
                  <el-image
                      class="item-image"
                      :src="idle.imgUrl"
                      fit="cover">
                    <div slot="error" class="image-slot">
                      <i class="el-icon-picture-outline"></i>
                      <span>暂无图片</span>
                    </div>
                  </el-image>
                  <div class="item-tag" v-if="getItemCategory(idle.idleLabel)">
                    {{getItemCategory(idle.idleLabel)}}
                  </div>
                  <div class="item-overlay"></div>
                </div>
                <div class="item-content">
                  <h3 class="item-title">{{idle.idleName}}</h3>
                  <div class="item-meta">
                    <div class="item-price" v-show="idle.idlePrice !== 0">¥{{idle.idlePrice}}</div>
                    <div class="item-place"><i class="el-icon-location"></i> {{idle.idlePlace}}</div>
                  </div>
                  <div class="item-time"><i class="el-icon-time"></i> {{idle.timeStr}}</div>
                  <div class="user-info">
                    <el-avatar :size="32" :src="idle.user.avatar" class="user-avatar"></el-avatar>
                    <div class="user-nickname">{{idle.user.nickname}}</div>
                  </div>
                </div>
              </div>
            </el-col>
          </el-row>

          <!-- 空状态 -->
          <div v-if="idleList.length === 0" class="empty-state">
            <i class="el-icon-shopping-bag-1 empty-icon"></i>
            <p class="empty-text">暂无商品</p>
            <p class="empty-desc">快去发布你的第一本闲置书吧</p>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-container" v-if="idleList.length > 0">
          <el-pagination
              background
              @current-change="handleCurrentChange"
              :current-page.sync="currentPage"
              :page-size="8"
              layout="prev, pager, next, jumper"
              :total="totalItem">
          </el-pagination>
        </div>
      </div>
      <app-foot></app-foot>
    </app-body>
  </div>
</template>

<script>
import AppHead from '../common/AppHeader.vue';
import AppBody from '../common/AppPageBody.vue'
import AppFoot from '../common/AppFoot.vue'

export default {
  name: "index",
  components: {
    AppHead,
    AppBody,
    AppFoot
  },
  data() {
    return {
      labelName: '0',
      idleList: [],
      currentPage: 1,
      totalItem: 1,
      categories: {
        '1': '软件工程',
        '2': '外语系',
        '3': '动画',
        '4': '电子信息',
        '5': '公告'
      }
    };
  },
  created() {
    this.findIdleTiem(1)
  },
  watch:{
    $route(to,from){
      this.labelName=to.query.labelName;
      let val=parseInt(to.query.page)?parseInt(to.query.page):1;
      this.currentPage=parseInt(to.query.page)?parseInt(to.query.page):1;
      this.findIdleTiem(val);
    }
  },
  methods: {
    findIdleTiem(page){
      const loading = this.$loading({
        lock: true,
        text: '加载数据中',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      });
      if(this.labelName>0){
        this.$api.findIdleTiemByLable({
          idleLabel:this.labelName,
          page: page,
          nums: 8
        }).then(res => {
          console.log(res);
          let list = res.data.list;
          for (let i = 0; i < list.length; i++) {
            list[i].timeStr = list[i].releaseTime.substring(0, 10) + " " + list[i].releaseTime.substring(11, 19);
            let pictureList = JSON.parse(list[i].pictureList);
            list[i].imgUrl = pictureList.length > 0 ? pictureList[0] : '';
          }
          this.idleList = list;
          this.totalItem=res.data.count;
          console.log(this.totalItem);
        }).catch(e => {
          console.log(e)
          this.$message.error('获取数据失败，请稍后重试');
        }).finally(()=>{
          loading.close();
        })
      }else{
        this.$api.findIdleTiem({
          page: page,
          nums: 8
        }).then(res => {
          console.log(res);
          let list = res.data.list;
          for (let i = 0; i < list.length; i++) {
            list[i].timeStr = list[i].releaseTime.substring(0, 10) + " " + list[i].releaseTime.substring(11, 19);
            let pictureList = JSON.parse(list[i].pictureList);
            list[i].imgUrl = pictureList.length > 0 ? pictureList[0] : '';
          }
          this.idleList = list;
          this.totalItem=res.data.count;
          console.log(this.totalItem);
        }).catch(e => {
          console.log(e)
          this.$message.error('获取数据失败，请稍后重试');
        }).finally(()=>{
          loading.close();
        })
      }
    },
    handleClick(tab, event) {
      console.log(this.labelName);
      this.$router.replace({query: {page: 1,labelName:this.labelName}});
    },
    handleCurrentChange(val) {
      console.log(`当前页: ${val}`);
      this.$router.replace({query: {page: val,labelName:this.labelName}});
    },
    toDetails(idle) {
      this.$router.push({path: '/details', query: {id: idle.id}});
    },
    getItemCategory(label) {
      return this.categories[label] || '';
    }
  }
}
</script>

<style scoped>
.page-header {
  position: relative;
  padding: 40px 0;
  margin-bottom: 30px;
  background: linear-gradient(135deg, #667eea 0%, #00c9a7 100%);
  overflow: hidden;
}

.header-content {
  position: relative;
  z-index: 2;
  text-align: center;
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
}

.page-title {
  font-size: 36px;
  font-weight: 700;
  color: white;
  margin-bottom: 12px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.highlight {
  color: #ffd666;
}

.page-description {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.9);
  margin: 0;
  font-weight: 300;
}

.header-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
}

.decoration-circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
}

.circle-1 {
  width: 80px;
  height: 80px;
  top: 20%;
  left: 10%;
  animation: float 6s ease-in-out infinite;
}

.circle-2 {
  width: 60px;
  height: 60px;
  top: 60%;
  right: 15%;
  animation: float 8s ease-in-out infinite;
}

.circle-3 {
  width: 40px;
  height: 40px;
  bottom: 20%;
  left: 20%;
  animation: float 10s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(180deg); }
}

.category-tabs {
  margin-bottom: 30px;
  padding: 0 20px;
}

.custom-tabs {
  background: transparent;
  border: none;
}

.custom-tabs >>> .el-tabs__header {
  margin-bottom: 0;
  border: none;
}

.custom-tabs >>> .el-tabs__nav-wrap {
  padding: 0 20px;
}

.custom-tabs >>> .el-tabs__nav-scroll {
  display: flex;
  justify-content: center;
}

.custom-tabs >>> .el-tabs__item {
  font-size: 15px;
  font-weight: 500;
  padding: 0 24px;
  height: 48px;
  line-height: 48px;
  color: #606266;
  transition: all 0.3s ease;
  border-radius: 24px;
  margin: 0 4px;
}

.custom-tabs >>> .el-tabs__item:hover {
  color: #409EFF;
  background: rgba(64, 158, 255, 0.05);
}

.custom-tabs >>> .el-tabs__item.is-active {
  color: white;
  background: linear-gradient(135deg, #409EFF, #66b1ff);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.custom-tabs >>> .el-tabs__active-bar {
  display: none;
}

.tab-icon {
  margin-right: 6px;
  font-size: 16px;
}

.items-container {
  padding: 0 20px;
  min-height: 400px;
}

.item-card {
  height: 100%;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  margin-bottom: 30px;
  background: #fff;
  cursor: pointer;
  position: relative;
}

.item-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

.item-image-container {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.item-image {
  width: 100%;
  height: 100%;
  transition: all 0.5s ease;
}

.item-card:hover .item-image {
  transform: scale(1.1);
}

.item-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, transparent 60%, rgba(0, 0, 0, 0.3));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.item-card:hover .item-overlay {
  opacity: 1;
}

.item-tag {
  position: absolute;
  top: 12px;
  right: 12px;
  background: linear-gradient(135deg, #ff6b6b, #ee5a52);
  color: white;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  z-index: 2;
  box-shadow: 0 2px 8px rgba(255, 107, 107, 0.3);
}

.item-content {
  padding: 20px;
}

.item-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.4;
}

.item-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.item-price {
  font-size: 20px;
  font-weight: 700;
  color: #ff6b6b;
}

.item-place {
  font-size: 13px;
  color: #909399;
  display: flex;
  align-items: center;
}

.item-place i {
  margin-right: 4px;
}

.item-time {
  font-size: 12px;
  color: #c0c4cc;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}

.item-time i {
  margin-right: 4px;
}

.user-info {
  display: flex;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.user-avatar {
  border: 2px solid #f0f0f0;
  transition: border-color 0.3s ease;
}

.item-card:hover .user-avatar {
  border-color: #409EFF;
}

.user-nickname {
  margin-left: 12px;
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

.pagination-container {
  display: flex;
  justify-content: center;
  padding: 40px 0;
}

.image-slot {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #f5f7fa, #e4e7ed);
  color: #909399;
  font-size: 14px;
}

.image-slot i {
  font-size: 32px;
  margin-bottom: 8px;
  opacity: 0.6;
}

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: #909399;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 20px;
  opacity: 0.5;
}

.empty-text {
  font-size: 18px;
  margin-bottom: 8px;
  font-weight: 500;
}

.empty-desc {
  font-size: 14px;
  opacity: 0.7;
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .items-container {
    padding: 0 15px;
  }

  .el-col-lg-6 {
    width: 25%;
  }
}

@media (max-width: 992px) {
  .page-title {
    font-size: 30px;
  }

  .page-description {
    font-size: 16px;
  }

  .el-col-md-8 {
    width: 33.333%;
  }
}

@media (max-width: 768px) {
  .page-header {
    padding: 30px 0;
  }

  .page-title {
    font-size: 26px;
  }

  .page-description {
    font-size: 15px;
  }

  .category-tabs {
    padding: 0 15px;
  }

  .custom-tabs >>> .el-tabs__item {
    padding: 0 16px;
    font-size: 14px;
    height: 42px;
    line-height: 42px;
  }

  .items-container {
    padding: 0 10px;
  }

  .item-image-container {
    height: 160px;
  }

  .el-col-sm-12 {
    width: 50%;
  }
}

@media (max-width: 576px) {
  .page-title {
    font-size: 22px;
  }

  .page-description {
    font-size: 14px;
  }

  .custom-tabs >>> .el-tabs__nav-scroll {
    justify-content: flex-start;
    overflow-x: auto;
  }

  .custom-tabs >>> .el-tabs__item {
    flex-shrink: 0;
  }

  .item-content {
    padding: 15px;
  }

  .el-col-xs-24 {
    width: 100%;
  }
}
</style>
