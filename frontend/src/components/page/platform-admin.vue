<template>
  <div class="admin-container">
    <el-container>
      <!-- 顶部导航栏 -->
      <el-header class="header-container">
        <div class="header-content">
          <div class="header-left">
            <div class="logo">
              <i class="el-icon-s-platform"></i>
            </div>
            <router-link to="/platform-admin" class="app-name">
              <span class="app-title">校园二手书交易平台</span>
              <span class="app-subtitle">管理后台</span>
            </router-link>
          </div>
          <div class="header-right">
            <div class="admin-profile">
              <el-avatar :size="36" :src="admin.avatar" class="admin-avatar">
                <i class="el-icon-user-solid"></i>
              </el-avatar>
              <div class="admin-info">
                <span class="admin-name">{{admin.nickname}}</span>
                <span class="admin-role">管理员</span>
              </div>
            </div>
            <el-button type="primary" size="small" @click="logout" class="logout-btn">
              <i class="el-icon-switch-button"></i>
              退出登录
            </el-button>
          </div>
        </div>
      </el-header>

      <el-container class="main-container">
        <!-- 侧边栏菜单 -->
        <el-aside width="240px" class="sidebar">
          <el-menu
              :default-active="mode.toString()"
              class="admin-menu"
              @select="handleSelect"
              background-color="#ffffff"
              text-color="#606266"
              active-text-color="#409EFF">
            <el-menu-item index="1">
              <i class="el-icon-goods menu-icon"></i>
              <span class="menu-text">闲置书管理</span>
            </el-menu-item>
            <el-menu-item index="2">
              <i class="el-icon-s-goods menu-icon"></i>
              <span class="menu-text">订单管理</span>
            </el-menu-item>
            <el-menu-item index="3">
              <i class="el-icon-s-custom menu-icon"></i>
              <span class="menu-text">用户管理</span>
            </el-menu-item>
            <el-menu-item index="4">
              <i class="el-icon-data-analysis menu-icon"></i>
              <span class="menu-text">数据统计</span>
            </el-menu-item>
          </el-menu>
        </el-aside>

        <!-- 主内容区域 -->
        <el-main class="content-area">
          <div class="content-wrapper">
            <IdleGoods v-if="mode == 1"></IdleGoods>
            <orderList v-if="mode == 2"></orderList>
            <userList v-if="mode == 3"></userList>
            <DataStatistics v-if="mode == 4"></DataStatistics>
          </div>
        </el-main>
      </el-container>
    </el-container>

    <!-- 页脚 -->
    <footer class="footer">
      <app-foot></app-foot>
    </footer>
  </div>
</template>

<script>
import AppFoot from '../common/AppFoot.vue'
import IdleGoods from '../common/IdleGoods.vue'
import orderList from '../common/orderList.vue'
import userList from '../common/userList.vue'
import DataStatistics from '../common/DataStatistics.vue'

export default {
  name: "platform-admin",
  components: {
    AppFoot,
    IdleGoods,
    orderList,
    userList,
    DataStatistics,
  },
  data() {
    return {
      mode: 1,
      admin: {
        nickname: '',
        avatar: '',
      },
    }
  },
  created() {
    // 设置默认头像
    this.admin.avatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png';

    // 通过API获取当前管理员信息
    this.$api.getUserInfo().then(res => {
      if (res.status_code === 1 && res.data.adminName) {
        this.$sta.adminName = res.data.adminName;
        this.admin.nickname = res.data.adminName;
      } else {
        // 如果API没有返回管理员名称，再尝试从全局状态获取
        if (this.$sta && this.$sta.adminName) {
          this.admin.nickname = this.$sta.adminName;
        }
      }
    }).catch(e => {
      console.log('获取管理员信息失败', e);
      // 发生错误时尝试从全局状态获取
      if (this.$sta && this.$sta.adminName) {
        this.admin.nickname = this.$sta.adminName;
      }
    });

    // 从URL参数中获取要显示的模块
    const pageParam = this.$route.query.page;
    if (pageParam) {
      this.mode = parseInt(pageParam);
    }
  },
  methods: {
    logout() {
      this.$confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        customClass: 'logout-confirm'
      }).then(() => {
        this.$api.loginOut({}).then(res => {
          if (res.status_code === 1) {
            this.$sta.isLogin = false;
            this.$sta.adminName = '';
            this.$message.success('退出登录成功');
            this.$router.push({path: '/login-admin'});
          }
        }).catch(e => {
          console.log(e);
          this.$message.error('退出登录失败');
        })
      }).catch(() => {
        // 用户取消操作
      });
    },
    handleSelect(val) {
      if (this.mode !== val) {
        this.mode = parseInt(val);
        // 更新URL参数，便于刷新页面后仍保持选中状态
        this.$router.push({
          query: {
            ...this.$route.query,
            page: val
          }
        });
      }
    }
  },
}
</script>

<style scoped>
.admin-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  position: relative;
}

/* 顶部导航栏样式 */
.header-container {
  height: 64px;
  background: #ff9671;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  border-bottom: 1px solid #e6e8eb;
}

.header-content {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  max-width: 100%;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.logo {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #409EFF 0%, #66b1ff 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.logo i {
  font-size: 20px;
  color: white;
}

.app-name {
  text-decoration: none;
  display: flex;
  flex-direction: column;
}

.app-title {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}

.app-subtitle {
  font-size: 12px;
  color: #fff;
  font-weight: 400;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.admin-profile {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 16px;
  border-radius: 12px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.admin-profile:hover {
  background: #f0f2f5;
}

.admin-avatar {
  border: 2px solid #e6e8eb;
  background: #409EFF;
}

.admin-info {
  display: flex;
  flex-direction: column;
}

.admin-name {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  line-height: 1.2;
}

.admin-role {
  font-size: 12px;
  color: #909399;
}

.logout-btn {
  border-radius: 8px;
  padding: 8px 16px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.logout-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.logout-btn i {
  margin-right: 6px;
}

/* 主容器样式 */
.main-container {
  padding-top: 64px;
  flex: 1;
  display: flex;
  min-height: calc(100vh - 124px);
}

/* 侧边栏样式 */
.sidebar {
  background: white;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.06);
  border-right: 1px solid #e6e8eb;
  height: calc(100vh - 64px);
  position: fixed;
  left: 0;
  top: 64px;
  z-index: 999;
}

.admin-menu {
  border: none;
  height: 100%;
  padding: 20px 0;
}

.admin-menu .el-menu-item {
  height: 52px;
  line-height: 52px;
  margin: 4px 12px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.admin-menu .el-menu-item:hover {
  background: #f0f7ff;
  transform: translateX(4px);
}

.admin-menu .el-menu-item.is-active {
  background: linear-gradient(135deg, #ecf5ff 0%, #d9ecff 100%);
  border-right: 3px solid #409EFF;
  color: #409EFF;
  font-weight: 600;
}

.menu-icon {
  margin-right: 12px;
  font-size: 18px;
  width: 20px;
  text-align: center;
}

.menu-text {
  font-size: 14px;
}

/* 主内容区域样式 */
.content-area {
  margin-left: 240px;
  padding: 0;
  background: transparent;
  width: calc(100% - 240px);
  min-height: calc(100vh - 124px);
}

.content-wrapper {
  padding: 24px;
  min-height: 100%;
}

/* 页脚样式 */
.footer {
  background: white;
  border-top: 1px solid #e6e8eb;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  z-index: 998;
}

/* 响应式设计 */
@media screen and (max-width: 1200px) {
  .sidebar {
    width: 200px;
  }

  .content-area {
    margin-left: 200px;
    width: calc(100% - 200px);
  }
}

@media screen and (max-width: 768px) {
  .header-content {
    padding: 0 16px;
  }

  .app-title {
    font-size: 16px;
  }

  .app-subtitle {
    font-size: 11px;
  }

  .admin-profile {
    padding: 6px 12px;
  }

  .admin-name {
    font-size: 13px;
  }

  .admin-role {
    font-size: 11px;
  }

  .sidebar {
    width: 180px;
  }

  .content-area {
    margin-left: 180px;
    width: calc(100% - 180px);
  }

  .content-wrapper {
    padding: 16px;
  }

  .admin-menu .el-menu-item {
    margin: 2px 8px;
    font-size: 13px;
  }

  .menu-icon {
    font-size: 16px;
    margin-right: 8px;
  }
}

@media screen and (max-width: 480px) {
  .header-content {
    padding: 0 12px;
  }

  .logo {
    width: 32px;
    height: 32px;
  }

  .logo i {
    font-size: 16px;
  }

  .app-title {
    font-size: 14px;
  }

  .admin-profile .admin-info {
    display: none;
  }

  .sidebar {
    width: 160px;
  }

  .content-area {
    margin-left: 160px;
    width: calc(100% - 160px);
  }
}

/* 动画效果 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
