<template>
  <div class="sign-in-container">
    <!-- 背景装饰元素 -->
    <div class="background-decoration">
      <div class="decoration-circle circle-1"></div>
      <div class="decoration-circle circle-2"></div>
      <div class="decoration-circle circle-3"></div>
    </div>

    <!-- 注册卡片 -->
    <div class="sign-in-card">
      <!-- 左侧欢迎区域 -->
      <div class="welcome-section">
        <div class="welcome-content">
          <div class="logo">
            <i class="el-icon-s-shop"></i>
          </div>
          <h1 class="welcome-title">加入校园二手书商城</h1>
          <p class="welcome-subtitle">开启您的闲置书籍交易之旅</p>
          <div class="feature-list">
            <div class="feature-item">
              <i class="el-icon-check"></i>
              <span>快速发布闲置物品</span>
            </div>
            <div class="feature-item">
              <i class="el-icon-check"></i>
              <span>安全可靠的交易保障</span>
            </div>
            <div class="feature-item">
              <i class="el-icon-check"></i>
              <span>专属校园交易社区</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧注册表单 -->
      <div class="form-section">
        <div class="form-content">
          <h2 class="form-title">创建账户</h2>
          <p class="form-subtitle">填写基本信息完成注册</p>

          <el-form class="sign-in-form">
            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-user"></i>
              </div>
              <el-input
                  placeholder="请输入昵称"
                  maxlength="30"
                  v-model="userInfo.nickname"
                  class="sign-in-input"
                  clearable
                  size="large">
              </el-input>
            </div>

            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-phone"></i>
              </div>
              <el-input
                  placeholder="请输入手机号"
                  maxlength="11"
                  v-model="userInfo.accountNumber"
                  class="sign-in-input"
                  clearable
                  size="large">
              </el-input>
            </div>

            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-lock"></i>
              </div>
              <el-input
                  placeholder="请输入密码"
                  show-password
                  maxlength="16"
                  v-model="userInfo.userPassword"
                  class="sign-in-input"
                  clearable
                  size="large">
              </el-input>
            </div>

            <div class="input-group">
              <div class="input-icon">
                <i class="el-icon-lock"></i>
              </div>
              <el-input
                  placeholder="请再次输入密码"
                  show-password
                  maxlength="16"
                  v-model="userPassword2"
                  @keyup.enter.native="signIn"
                  class="sign-in-input"
                  clearable
                  size="large">
              </el-input>
            </div>

            <el-button
                type="primary"
                class="sign-in-btn"
                @click="signIn"
                :loading="loading">
              {{ loading ? '注册中...' : '立即注册' }}
            </el-button>
          </el-form>

          <div class="form-footer">
            <div class="footer-text">
              <span>已有账户？</span>
              <a class="login-link" @click="toLogin">
                <i class="el-icon-user"></i>
                立即登录
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "sign-in",
  data(){
    return{
      userPassword2:'',
      userInfo:{
        accountNumber:'',
        userPassword:'',
        nickname:''
      },
      loading: false
    };
  },
  methods:{
    toLogin(){
      this.$router.replace({path: '/login'});
    },
    signIn(){
      // 表单验证
      if(!this.userInfo.nickname || !this.userInfo.accountNumber || !this.userInfo.userPassword || !this.userPassword2){
        this.$message.error('请填写完整的注册信息！');
        return;
      }

      if(this.userInfo.nickname.length < 2){
        this.$message.error('昵称至少需要2个字符！');
        return;
      }

      if(this.userInfo.accountNumber.length !== 11){
        this.$message.error('请输入11位手机号！');
        return;
      }

      if(this.userInfo.userPassword.length < 6){
        this.$message.error('密码至少需要6位！');
        return;
      }

      if(this.userInfo.userPassword !== this.userPassword2){
        this.$message.error('两次输入的密码不一致！');
        return;
      }

      this.loading = true;
      this.$api.signIn(this.userInfo).then(res=>{
        if(res.status_code === 1){
          this.$message({
            message: '注册成功！',
            type: 'success'
          });
          this.$router.replace({path: '/login'});
        }else {
          this.$message.error(res.msg || '注册失败，用户已存在！');
        }
      }).catch(e=>{
        console.log(e);
        this.$message.error('注册失败，网络异常！');
      }).finally(() => {
        this.loading = false;
      });
    }
  }
}
</script>

<style scoped>
.sign-in-container {
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
  top: 15%;
  right: 8%;
  animation-delay: 0s;
}

.circle-2 {
  width: 150px;
  height: 150px;
  top: 65%;
  left: 5%;
  animation-delay: 2s;
}

.circle-3 {
  width: 100px;
  height: 100px;
  bottom: 15%;
  right: 20%;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) scale(1); }
  50% { transform: translateY(-20px) scale(1.05); }
}

.sign-in-card {
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
  background: linear-gradient(135deg, #67C23A 0%, #85ce61 100%);
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

.sign-in-form {
  width: 100%;
}

.input-group {
  position: relative;
  margin-bottom: 20px;
}

.input-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 2;
  color: #c0c4cc;
}

.sign-in-input >>> .el-input__inner {
  padding-left: 45px;
  height: 48px;
  border-radius: 12px;
  border: 2px solid #f0f2f5;
  background: #fafbfc;
  font-size: 14px;
  transition: all 0.3s ease;
}

.sign-in-input >>> .el-input__inner:focus {
  border-color: #67C23A;
  background: white;
  box-shadow: 0 0 0 3px rgba(103, 194, 58, 0.1);
}

.sign-in-input >>> .el-input__inner:hover {
  border-color: #dcdfe6;
}

.sign-in-btn {
  width: 100%;
  height: 48px;
  border-radius: 12px;
  background: #67C23A;
  border: none;
  font-size: 16px;
  font-weight: 600;
  margin-top: 10px;
  transition: all 0.3s ease;
}

.sign-in-btn:hover {
  background: #85ce61;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(103, 194, 58, 0.3);
}

.sign-in-btn:active {
  transform: translateY(0);
}

.form-footer {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #f0f2f5;
  text-align: center;
}

.footer-text {
  color: #606266;
  font-size: 14px;
}

.login-link {
  color: #67C23A;
  text-decoration: none;
  margin-left: 8px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
  padding: 4px 8px;
  border-radius: 6px;
}

.login-link:hover {
  color: #85ce61;
  background: rgba(103, 194, 58, 0.05);
}

.login-link i {
  margin-right: 4px;
  font-size: 12px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .sign-in-card {
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
}

@media (max-width: 480px) {
  .sign-in-container {
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

/* 密码强度提示 */
.password-strength {
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
}

.password-strength.weak {
  color: #f56c6c;
}

.password-strength.medium {
  color: #e6a23c;
}

.password-strength.strong {
  color: #67c23a;
}
</style>
