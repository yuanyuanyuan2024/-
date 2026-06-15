<template>
  <div class="login-container">
    <!-- 背景装饰元素 -->
    <div class="background-decoration">
      <div class="decoration-circle circle-1"></div>
      <div class="decoration-circle circle-2"></div>
      <div class="decoration-circle circle-3"></div>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <!-- 左侧欢迎区域 -->
      <div class="welcome-section">
        <div class="welcome-content">
          <div class="logo">
            <i class="el-icon-s-shop"></i>
          </div>
          <h1 class="welcome-title">校园二手书交易商城</h1>
          <p class="welcome-subtitle">让闲置书籍找到新主人</p>
          <div class="feature-list">
            <div class="feature-item">
              <i class="el-icon-check"></i>
              <span>安全可靠的交易环境</span>
            </div>
            <div class="feature-item">
              <i class="el-icon-check"></i>
              <span>便捷的校园交易体验</span>
            </div>
            <div class="feature-item">
              <i class="el-icon-check"></i>
              <span>丰富的商品种类</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧登录表单 -->
      <div class="form-section">
        <div class="form-content">
          <h2 class="form-title">欢迎回来</h2>
          <p class="form-subtitle">请登录您的账户</p>

          <el-form ref="form" :model="userForm" class="login-form">
            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-user"></i>
              </div>
              <el-input
                  placeholder="请输入手机号"
                  v-model="userForm.accountNumber"
                  class="login-input"
                  size="large">
              </el-input>
            </div>

            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-lock"></i>
              </div>
              <el-input
                  placeholder="请输入密码"
                  v-model="userForm.userPassword"
                  class="login-input"
                  @keyup.enter.native="login"
                  show-password
                  size="large">
              </el-input>
            </div>

            <el-button
                type="primary"
                class="login-btn"
                @click="login"
                :loading="loading">
              {{ loading ? '登录中...' : '登录' }}
            </el-button>
          </el-form>

          <div class="form-footer">
            <div class="footer-links">
              <router-link to="/sign-in" class="link-item">
                <i class="el-icon-user"></i>
                注册新账户
              </router-link>
              <router-link to="/login-admin" class="link-item">
                <i class="el-icon-s-custom"></i>
                管理员登录
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "login",
  data() {
    return {
      userForm: {
        accountNumber: '',
        userPassword: ''
      },
      loading: false
    };
  },

  methods: {
    login() {
      if (!this.userForm.accountNumber || !this.userForm.userPassword) {
        this.$message.warning('请输入手机号和密码');
        return;
      }

      this.loading = true;
      this.$api.userLogin({
        accountNumber: this.userForm.accountNumber,
        userPassword: this.userForm.userPassword
      }).then(res => {
        console.log(res);
        if (res.status_code === 1) {
          res.data.signInTime = res.data.signInTime.substring(0,10);
          this.$globalData.userInfo = res.data;
          this.$message.success('登录成功！');
          this.$router.replace({path: '/index'});
        } else {
          this.$message.error(res.msg);
        }
      }).catch(error => {
        this.$message.error('登录失败，请稍后重试');
        console.error(error);
      }).finally(() => {
        this.loading = false;
      });
    }
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url("../../img/bg.png") no-repeat center center;
  background-size: cover; /* 关键属性：图片覆盖整个容器 */
  padding: 20px;
  position: relative;
  overflow: hidden;
}

.background-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.decoration-circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(64, 158, 255, 0.05);
  animation: float 6s ease-in-out infinite;
}

.circle-1 {
  width: 200px;
  height: 200px;
  top: 10%;
  left: 5%;
  animation-delay: 0s;
}

.circle-2 {
  width: 150px;
  height: 150px;
  top: 60%;
  right: 8%;
  animation-delay: 2s;
}

.circle-3 {
  width: 100px;
  height: 100px;
  bottom: 20%;
  left: 15%;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) scale(1); }
  50% { transform: translateY(-20px) scale(1.05); }
}

.login-card {
  width: 900px;
  height: 550px;
  background: white;
  border-radius: 20px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  display: flex;
  overflow: hidden;
  position: relative;
  z-index: 1;
}

/* 左侧欢迎区域 */
.welcome-section {
  flex: 1;
  background: linear-gradient(135deg, #409EFF 0%, #66b1ff 100%);
  color: white;
  padding: 50px 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.welcome-content {
  text-align: center;
}

.logo {
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 30px;
}

.logo i {
  font-size: 36px;
  color: white;
}

.welcome-title {
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 15px;
  color: white;
}

.welcome-subtitle {
  font-size: 16px;
  opacity: 0.9;
  margin-bottom: 40px;
  color: rgba(255, 255, 255, 0.9);
}

.feature-list {
  text-align: left;
  max-width: 250px;
  margin: 0 auto;
}

.feature-item {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  font-size: 14px;
}

.feature-item i {
  margin-right: 10px;
  color: rgba(255, 255, 255, 0.9);
}

.feature-item span {
  color: rgba(255, 255, 255, 0.9);
}

/* 右侧表单区域 */
.form-section {
  flex: 1;
  padding: 60px 50px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.form-content {
  width: 100%;
  max-width: 320px;
}

.form-title {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  text-align: center;
}

.form-subtitle {
  color: #909399;
  text-align: center;
  margin-bottom: 40px;
  font-size: 14px;
}

.login-form {
  width: 100%;
}

.input-group {
  position: relative;
  margin-bottom: 25px;
}

.input-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 2;
  color: #c0c4cc;
}

.login-input >>> .el-input__inner {
  padding-left: 45px;
  height: 48px;
  border-radius: 12px;
  border: 2px solid #f0f2f5;
  background: #fafbfc;
  font-size: 14px;
  transition: all 0.3s ease;
}

.login-input >>> .el-input__inner:focus {
  border-color: #409EFF;
  background: white;
  box-shadow: 0 0 0 3px rgba(64, 158, 255, 0.1);
}

.login-input >>> .el-input__inner:hover {
  border-color: #dcdfe6;
}

.login-btn {
  width: 100%;
  height: 48px;
  border-radius: 12px;
  background: #409EFF;
  border: none;
  font-size: 16px;
  font-weight: 600;
  margin-top: 10px;
  transition: all 0.3s ease;
}

.login-btn:hover {
  background: #66b1ff;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(64, 158, 255, 0.3);
}

.login-btn:active {
  transform: translateY(0);
}

.form-footer {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #f0f2f5;
}

.footer-links {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.link-item {
  display: flex;
  align-items: center;
  color: #409EFF;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s ease;
  padding: 8px 12px;
  border-radius: 8px;
}

.link-item:hover {
  color: #66b1ff;
  background: rgba(64, 158, 255, 0.05);
  transform: translateY(-1px);
}

.link-item i {
  margin-right: 6px;
  font-size: 12px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-card {
    flex-direction: column;
    height: auto;
    width: 100%;
    max-width: 400px;
  }

  .welcome-section {
    padding: 40px 30px;
  }

  .form-section {
    padding: 40px 30px;
  }

  .welcome-title {
    font-size: 24px;
  }

  .form-title {
    font-size: 22px;
  }

  .footer-links {
    flex-direction: column;
    gap: 15px;
  }

  .link-item {
    justify-content: center;
    width: 100%;
  }
}

@media (max-width: 480px) {
  .login-container {
    padding: 10px;
  }

  .welcome-section,
  .form-section {
    padding: 30px 20px;
  }

  .welcome-title {
    font-size: 20px;
  }

  .form-title {
    font-size: 20px;
  }

  .feature-list {
    max-width: 100%;
  }
}
</style>
