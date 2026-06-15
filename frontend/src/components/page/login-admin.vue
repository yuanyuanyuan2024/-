<template>
  <div class="admin-login-container">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="decoration-grid">
        <div class="grid-line"></div>
        <div class="grid-line"></div>
        <div class="grid-line"></div>
      </div>
      <div class="floating-shape shape-1"></div>
      <div class="floating-shape shape-2"></div>
      <div class="floating-shape shape-3"></div>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <!-- 左侧品牌区域 -->
      <div class="brand-section">
        <div class="brand-content">
          <div class="admin-logo">
            <i class="el-icon-s-platform"></i>
          </div>
          <h1 class="system-name">校园二手书交易平台</h1>
          <p class="system-subtitle">管理后台系统</p>
          <div class="system-features">
            <div class="feature-item">
              <i class="el-icon-monitor"></i>
              <span>数据监控</span>
            </div>
            <div class="feature-item">
              <i class="el-icon-setting"></i>
              <span>系统管理</span>
            </div>
            <div class="feature-item">
              <i class="el-icon-data-analysis"></i>
              <span>统计分析</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧登录表单 -->
      <div class="form-section">
        <div class="form-content">
          <div class="form-header">
            <h2 class="form-title">管理员登录</h2>
            <p class="form-subtitle">请输入管理员账号密码</p>
          </div>

          <el-form ref="form" :model="userForm" class="login-form">
            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-user"></i>
              </div>
              <el-input
                  placeholder="请输入管理员账号"
                  v-model="userForm.accountNumber"
                  class="login-input"
                  size="large"
                  clearable>
              </el-input>
            </div>

            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-lock"></i>
              </div>
              <el-input
                  placeholder="请输入管理员密码"
                  v-model="userForm.adminPassword"
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
              <i class="el-icon-key"></i>
              {{ loading ? '登录中...' : '登录系统' }}
            </el-button>
          </el-form>

          <div class="form-footer">
            <div class="footer-links">
              <router-link to="/login" class="link-item">
                <i class="el-icon-user"></i>
                学生登录入口
              </router-link>
            </div>
            <div class="security-tip">
              <i class="el-icon-warning"></i>
              请妥善保管管理员账号信息
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
        adminPassword: ''
      },
      loading: false
    };
  },
  methods: {
    login() {
      if (!this.userForm.accountNumber || !this.userForm.adminPassword) {
        this.$message.warning('请输入管理员账号和密码');
        return;
      }

      this.loading = true;
      this.$api.adminLogin({
        accountNumber: this.userForm.accountNumber,
        adminPassword: this.userForm.adminPassword
      }).then(res => {
        console.log(res);
        if (res.status_code === 1) {
          console.log(res);
          this.$sta.isLogin = true;
          this.$sta.adminName = res.data.adminName;
          this.$message.success('登录成功！');
          this.$router.replace({path:'/platform-admin'});
        } else {
          this.$message.error('登录失败，账号或密码错误！');
        }
      }).catch(error => {
        this.$message.error('登录失败，请检查网络连接');
        console.error(error);
      }).finally(() => {
        this.loading = false;
      });
    }
  }
}
</script>

<style scoped>
.admin-login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url("../../img/4.png") no-repeat center center;
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

.decoration-grid {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0.1;
}

.grid-line {
  position: absolute;
  background: white;
}

.grid-line:nth-child(1) {
  top: 25%;
  left: 0;
  right: 0;
  height: 1px;
}

.grid-line:nth-child(2) {
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
}

.grid-line:nth-child(3) {
  top: 75%;
  left: 0;
  right: 0;
  height: 1px;
}

.floating-shape {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 8s ease-in-out infinite;
}

.shape-1 {
  width: 120px;
  height: 120px;
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.shape-2 {
  width: 80px;
  height: 80px;
  top: 70%;
  right: 15%;
  animation-delay: 2s;
}

.shape-3 {
  width: 60px;
  height: 60px;
  bottom: 20%;
  left: 20%;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(180deg); }
}

.login-card {
  width: 900px;
  height: 550px;
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  display: flex;
  overflow: hidden;
  position: relative;
  z-index: 1;
}

/* 左侧品牌区域 */
.brand-section {
  flex: 1;
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  color: white;
  padding: 50px 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.brand-content {
  text-align: center;
}

.admin-logo {
  width: 100px;
  height: 100px;
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 30px;
  box-shadow: 0 10px 30px rgba(52, 152, 219, 0.3);
}

.admin-logo i {
  font-size: 48px;
  color: white;
}

.system-name {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 8px;
  color: white;
}

.system-subtitle {
  font-size: 16px;
  opacity: 0.8;
  margin-bottom: 40px;
  color: rgba(255, 255, 255, 0.9);
}

.system-features {
  text-align: left;
  max-width: 200px;
  margin: 0 auto;
}

.feature-item {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  font-size: 14px;
  padding: 8px 12px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.feature-item:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateX(5px);
}

.feature-item i {
  margin-right: 10px;
  color: #3498db;
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
  background: white;
}

.form-content {
  width: 100%;
  max-width: 320px;
}

.form-header {
  text-align: center;
  margin-bottom: 40px;
}

.form-title {
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 8px;
}

.form-subtitle {
  color: #7f8c8d;
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
  color: #95a5a6;
  font-size: 18px;
}

.login-input >>> .el-input__inner {
  padding-left: 50px;
  height: 52px;
  border-radius: 12px;
  border: 2px solid #ecf0f1;
  background: #fafbfc;
  font-size: 15px;
  transition: all 0.3s ease;
  font-weight: 500;
}

.login-input >>> .el-input__inner:focus {
  border-color: #3498db;
  background: white;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
}

.login-input >>> .el-input__inner:hover {
  border-color: #bdc3c7;
}

.login-btn {
  width: 100%;
  height: 52px;
  border-radius: 12px;
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  border: none;
  font-size: 16px;
  font-weight: 600;
  margin-top: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(52, 152, 219, 0.4);
}

.login-btn:active {
  transform: translateY(0);
}

.login-btn i {
  margin-right: 8px;
}

.form-footer {
  margin-top: 30px;
  text-align: center;
}

.footer-links {
  margin-bottom: 20px;
}

.link-item {
  display: inline-flex;
  align-items: center;
  color: #3498db;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s ease;
  padding: 8px 16px;
  border-radius: 8px;
  background: rgba(52, 152, 219, 0.05);
}

.link-item:hover {
  color: #2980b9;
  background: rgba(52, 152, 219, 0.1);
  transform: translateY(-1px);
}

.link-item i {
  margin-right: 6px;
  font-size: 12px;
}

.security-tip {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #95a5a6;
  font-size: 12px;
  padding: 8px 12px;
  background: #f8f9fa;
  border-radius: 6px;
}

.security-tip i {
  margin-right: 6px;
  color: #e74c3c;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-card {
    flex-direction: column;
    height: auto;
    width: 100%;
    max-width: 400px;
  }

  .brand-section {
    padding: 40px 30px;
  }

  .form-section {
    padding: 40px 30px;
  }

  .system-name {
    font-size: 20px;
  }

  .form-title {
    font-size: 24px;
  }
}

@media (max-width: 480px) {
  .admin-login-container {
    padding: 10px;
  }

  .brand-section,
  .form-section {
    padding: 30px 20px;
  }

  .system-name {
    font-size: 18px;
  }

  .form-title {
    font-size: 22px;
  }

  .system-features {
    max-width: 100%;
  }
}
</style>
