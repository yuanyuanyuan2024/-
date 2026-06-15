<template>
  <div class="header">
    <div class="header-container">
      <div class="app-name">
        <router-link to="/">
          <i class="el-icon-s-shop"></i>
          <span class="app-name-text">校园二手书交易平台</span>
        </router-link>
      </div>
      <div class="search-container">
        <el-input
            placeholder="搜索二手书..."
            v-model="searchValue"
            @keyup.enter.native="searchIdle"
            prefix-icon="el-icon-search"
            class="search-input"
            clearable>
          <el-button slot="append" icon="el-icon-search" @click="searchIdle" class="search-btn">搜索</el-button>
        </el-input>
      </div>
      <div class="action-buttons">
        <el-button type="primary" icon="el-icon-plus" class="publish-btn" @click="toRelease">
          <span class="btn-text">发布闲置</span>
        </el-button>
        <el-button type="default" icon="el-icon-chat-dot-round" class="message-btn" @click="toMessage">
          <span class="btn-text">消息</span>
        </el-button>

        <router-link v-if="!isLogin" class="user-name-text login-btn" to="/login">
          <i class="el-icon-user"></i>
          <span class="btn-text">登录</span>
        </router-link>

        <el-dropdown trigger="click" v-else class="user-dropdown">
          <div class="user-info">
            <div class="user-name">{{nicknameValue?nicknameValue:nickname}}</div>
            <el-avatar :size="36" :src="avatarValue?avatarValue:avatar" class="user-avatar"></el-avatar>
          </div>
          <el-dropdown-menu slot="dropdown" class="dropdown-menu">
            <el-dropdown-item>
              <div @click="toMe" class="dropdown-item">
                <i class="el-icon-user-solid"></i> 个人中心
              </div>
            </el-dropdown-item>
            <el-dropdown-item divided>
              <div @click="loginOut" class="dropdown-item logout">
                <i class="el-icon-switch-button"></i> 退出登录
              </div>
            </el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Header',
  props: ['searchInput','nicknameValue','avatarValue'],
  data() {
    return {
      searchValue: this.searchInput,
      nickname:'登录',
      avatar:'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
      isLogin:false
    };
  },
  created(){
    if(! this.$globalData.userInfo.nickname){
      this.$api.getUserInfo().then(res=>{
        console.log('Header getUserInfo:',res);
        if(res.status_code===1){
          this.nickname=res.data.nickname;
          this.avatar=res.data.avatar;
          res.data.signInTime=res.data.signInTime.substring(0,10);
          this.$globalData.userInfo=res.data;
          this.isLogin=true;
        }
      })
    }else {
      this.nickname=this.$globalData.userInfo.nickname;
      this.avatar=this.$globalData.userInfo.avatar;
      this.isLogin=true;
    }
  },
  methods: {
    searchIdle() {
      if(this.searchValue && this.searchValue.trim() !== '') {
        if ('/search' !== this.$route.path) {
          this.$router.push({path: '/search', query: {searchValue: this.searchValue}});
        } else {
          this.$router.replace({path: '/search', query: {searchValue: this.searchValue}});
          this.$router.go(0);
        }
      } else {
        this.$message.warning('请输入搜索关键词');
      }
    },
    toMe() {
      if ('/me' !== this.$route.path) {
        this.$router.push({path: '/me'});
      }
    },
    toMessage(){
      if ('/message' !== this.$route.path) {
        this.$router.push({path: '/message'});
      }
    },
    toRelease(){
      if ('/release' !== this.$route.path) {
        this.$router.push({path: '/release'});
      }
    },
    loginOut(){
      this.$api.logout().then(res=>{
        if(res.status_code===1){
          this.$globalData.userInfo={};
          console.log("login out");
          this.$message.success('退出登录成功');
          if ('/index' === this.$route.path) {
            this.$router.go(0);
          }else {
            this.$router.push({path: '/index'});
          }
        }else {
          this.$message.error('网络或系统异常，退出登录失败！');
        }
      });
    }
  }
};
</script>

<style scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  width: 100%;
  height: 64px;
  background: #ffffff;
  display: flex;
  justify-content: center;
  border-bottom: 1px solid #f0f2f5;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  z-index: 1000;
  transition: all 0.3s ease;
}

.header-container {
  width: 1200px;
  max-width: 95%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.app-name {
  flex-shrink: 0;
  margin-right: 20px;
}

.app-name a {
  color: #00c9a7;
  font-size: 20px;
  font-weight: 600;
  text-decoration: none;
  display: flex;
  align-items: center;
  transition: all 0.3s;
}

.app-name a:hover {
  color: #66b1ff;
  transform: translateY(-1px);
}

.app-name i {
  margin-right: 10px;
  font-size: 24px;
}

.app-name-text {
  white-space: nowrap;
}

.search-container {
  flex-grow: 1;
  max-width: 500px;
  margin: 0 20px;
}

.search-input {
  border-radius: 20px;
  overflow: hidden;
}

.search-input >>> .el-input__inner {
  border-radius: 20px 0 0 20px;
  border: 1px solid #e6e8eb;
  border-right: none;
  height: 40px;
  transition: all 0.3s;
}

.search-input >>> .el-input__inner:focus {
  border-color: #00c9a7;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
}

.search-btn {
  border-radius: 0 20px 20px 0;
  height: 40px;
  background: #00c9a7;
  border-color: #00c9a7;
  color: white;
  transition: all 0.3s;
}

.search-btn:hover {
  background: #66b1ff;
  border-color: #66b1ff;
  transform: translateY(-1px);
}

.action-buttons {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  gap: 12px;
}

.publish-btn, .message-btn {
  border-radius: 20px;
  height: 40px;
  padding: 0 16px;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.publish-btn {
  background: linear-gradient(135deg, #00c9a7, #66b1ff);
  border: none;
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
}

.publish-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.message-btn {
  border: 1px solid #e6e8eb;
  background: white;
  color: #606266;
}

.message-btn:hover {
  border-color: #00c9a7;
  color: #00c9a7;
  transform: translateY(-1px);
}

.user-name-text {
  font-size: 16px;
  font-weight: 600;
  color: #00c9a7;
  cursor: pointer;
  text-decoration: none;
  display: flex;
  align-items: center;
  transition: all 0.3s;
  padding: 8px 16px;
  border-radius: 20px;
  border: 1px solid transparent;
}

.user-name-text:hover {
  color: #66b1ff;
  background: rgba(64, 158, 255, 0.05);
  border-color: rgba(64, 158, 255, 0.2);
  transform: translateY(-1px);
}

.login-btn i {
  margin-right: 6px;
}

.user-dropdown {
  cursor: pointer;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 4px 8px 4px 12px;
  border-radius: 24px;
  transition: all 0.3s;
  border: 1px solid transparent;
}

.user-info:hover {
  background-color: rgba(64, 158, 255, 0.05);
  border-color: rgba(64, 158, 255, 0.1);
  transform: translateY(-1px);
}

.user-name {
  font-size: 15px;
  color: #00c9a7;
  margin-right: 10px;
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.user-avatar {
  border: 2px solid #f0f2f5;
  transition: all 0.3s;
}

.user-info:hover .user-avatar {
  border-color: #00c9a7;
}

.dropdown-menu {
  min-width: 140px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border: none;
  padding: 8px 0;
}

.dropdown-item {
  display: flex;
  align-items: center;
  font-size: 14px;
  padding: 8px 16px;
  transition: all 0.2s;
}

.dropdown-item:hover {
  background-color: rgba(64, 158, 255, 0.08);
}

.dropdown-item i {
  margin-right: 8px;
  width: 16px;
  text-align: center;
}

.logout {
  color: #f56c6c;
}

.btn-text {
  margin-left: 4px;
}

/* 响应式调整 */
@media (max-width: 992px) {
  .app-name a {
    font-size: 18px;
  }

  .app-name-text {
    max-width: 180px;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .search-container {
    max-width: 300px;
  }

  .publish-btn, .message-btn {
    padding: 0 12px;
  }

  .btn-text {
    display: none;
  }

  .user-name {
    max-width: 60px;
  }
}

@media (max-width: 768px) {
  .header {
    height: 56px;
  }

  .app-name-text {
    display: none;
  }

  .app-name i {
    margin-right: 0;
    font-size: 22px;
  }

  .search-container {
    max-width: 200px;
    margin: 0 10px;
  }

  .action-buttons {
    gap: 8px;
  }

  .publish-btn, .message-btn {
    padding: 0 10px;
    height: 36px;
  }

  .user-name {
    font-size: 14px;
    margin-right: 6px;
    max-width: 50px;
  }

  .user-avatar {
    width: 32px !important;
    height: 32px !important;
  }
}

@media (max-width: 480px) {
  .search-container {
    max-width: 150px;
  }

  .user-name {
    display: none;
  }

  .user-info {
    padding: 4px;
  }
}
</style>
