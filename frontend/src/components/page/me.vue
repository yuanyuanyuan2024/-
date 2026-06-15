<template>
  <div>
    <app-head :nickname-value="userInfo.nickname" :avatarValue="userInfo.avatar"></app-head>
    <app-body>
      <!-- 个人资料页面 -->
      <div v-show="!eidtAddress" class="profile-container">
        <!-- 用户信息卡片 -->
        <el-card class="user-profile-card" shadow="never">
          <div class="user-info-container">
            <div class="user-avatar-section">
              <el-upload
                  action="http://localhost:8080/file/"
                  :on-success="fileHandleSuccess"
                  :file-list="imgFileList"
                  :show-file-list="false"
                  accept="image/*"
                  class="avatar-uploader"
              >
                <div class="avatar-wrapper">
                  <el-avatar :size="100" :src="userInfo.avatar" class="user-avatar">
                    <i class="el-icon-user avatar-placeholder"></i>
                  </el-avatar>
                  <div class="avatar-overlay">
                    <i class="el-icon-camera"></i>
                    <span>更换头像</span>
                  </div>
                </div>
              </el-upload>
              <div class="user-basic-info">
                <h2 class="user-nickname">{{userInfo.nickname}}</h2>
                <p class="user-join-time">
                  <i class="el-icon-time"></i>
                  {{userInfo.signInTime}} 加入平台
                </p>
                <div class="user-stats">
                  <div class="stat-item">
                    <span class="stat-number">{{dataList[0].length}}</span>
                    <span class="stat-label">在售商品</span>
                  </div>
                  <div class="stat-item">
                    <span class="stat-number">{{dataList[4].length}}</span>
                    <span class="stat-label">购买记录</span>
                  </div>
                  <div class="stat-item">
                    <span class="stat-number">{{dataList[3].length}}</span>
                    <span class="stat-label">出售记录</span>
                  </div>
                </div>
              </div>
            </div>

            <div class="user-actions">
              <el-button type="primary" icon="el-icon-edit" round @click="userInfoDialogVisible = true">
                编辑个人信息
              </el-button>
              <el-button type="warning" icon="el-icon-location" round @click="eidtAddress=true">
                管理收货地址
              </el-button>
            </div>
          </div>
        </el-card>

        <!-- 编辑个人信息对话框 -->
        <el-dialog
            title="编辑个人信息"
            :visible.sync="userInfoDialogVisible"
            width="480px"
            center
            @close="finishEdit">
          <div class="edit-form">
            <div class="form-group">
              <label class="form-label">昵称</label>
              <div class="input-with-action">
                <el-input
                    v-model="userInfo.nickname"
                    :disabled="notUserNicknameEdit"
                    placeholder="请输入昵称"
                    prefix-icon="el-icon-user"
                    @change="saveUserNickname">
                </el-input>
                <el-button
                    type="warning"
                    icon="el-icon-edit"
                    @click="notUserNicknameEdit = false"
                    class="edit-toggle-btn">
                  {{ notUserNicknameEdit ? '编辑' : '保存' }}
                </el-button>
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">密码</label>
              <div v-if="userPasswordEdit" class="password-edit-group">
                <el-input
                    v-model="userPassword1"
                    placeholder="请输入原密码"
                    prefix-icon="el-icon-lock"
                    show-password
                    class="password-input">
                </el-input>
                <el-input
                    v-model="userPassword2"
                    placeholder="请输入新密码"
                    prefix-icon="el-icon-lock"
                    show-password
                    class="password-input">
                </el-input>
                <el-input
                    v-model="userPassword3"
                    placeholder="请再次输入新密码"
                    prefix-icon="el-icon-lock"
                    show-password
                    class="password-input">
                </el-input>
                <div class="password-actions">
                  <el-button type="primary" icon="el-icon-check" @click="savePassword">
                    确认修改
                  </el-button>
                  <el-button @click="userPasswordEdit = false">
                    取消
                  </el-button>
                </div>
              </div>
              <div v-else class="input-with-action">
                <el-input
                    value="******"
                    disabled
                    prefix-icon="el-icon-lock"
                    show-password>
                </el-input>
                <el-button
                    type="warning"
                    icon="el-icon-edit"
                    @click="userPasswordEdit = true"
                    class="edit-toggle-btn">
                  修改密码
                </el-button>
              </div>
            </div>
          </div>
          <span slot="footer" class="dialog-footer">
                        <el-button type="primary" @click="userInfoDialogVisible=false">完成</el-button>
                    </span>
        </el-dialog>

        <!-- 内容标签页 -->
        <el-card class="user-content-card" shadow="never">
          <div class="content-tabs">
            <el-tabs v-model="activeName" @tab-click="handleClick" class="custom-tabs">
              <el-tab-pane name="1">
                <template #label>
                                    <span class="tab-label">
                                        <i class="el-icon-upload tab-icon"></i>
                                        在售商品
                                        <el-badge :value="dataList[0].length" :max="99" class="tab-badge" />
                                    </span>
                </template>
              </el-tab-pane>
              <el-tab-pane name="2">
                <template #label>
                                    <span class="tab-label">
                                        <i class="el-icon-download tab-icon"></i>
                                        已下架
                                        <el-badge :value="dataList[1].length" :max="99" class="tab-badge" />
                                    </span>
                </template>
              </el-tab-pane>
              <el-tab-pane name="3">
                <template #label>
                                    <span class="tab-label">
                                        <i class="el-icon-shopping-cart-full tab-icon"></i>
                                        我的收藏
                                        <el-badge :value="dataList[2].length" :max="99" class="tab-badge" />
                                    </span>
                </template>
              </el-tab-pane>
              <el-tab-pane name="4">
                <template #label>
                                    <span class="tab-label">
                                        <i class="el-icon-sold-out tab-icon"></i>
                                        出售记录
                                        <el-badge :value="dataList[3].length" :max="99" class="tab-badge" />
                                    </span>
                </template>
              </el-tab-pane>
              <el-tab-pane name="5">
                <template #label>
                                    <span class="tab-label">
                                        <i class="el-icon-shopping-bag-1 tab-icon"></i>
                                        购买记录
                                        <el-badge :value="dataList[4].length" :max="99" class="tab-badge" />
                                    </span>
                </template>
              </el-tab-pane>
            </el-tabs>

            <!-- 商品列表 -->
            <div class="item-list">
              <div v-if="dataList[activeName-1].length === 0" class="empty-state">
                <i :class="getEmptyIcon(activeName)" class="empty-icon"></i>
                <p class="empty-text">{{getEmptyText(activeName)}}</p>
                <p class="empty-action" v-if="activeName === '1'">
                  <el-button type="primary" icon="el-icon-plus" @click="$router.push('/release')">
                    去发布商品
                  </el-button>
                </p>
              </div>

              <div v-else class="item-grid">
                <div
                    v-for="(item,index) in dataList[activeName-1]"
                    :key="index"
                    class="item-card"
                    @click="toDetails(activeName,item)">
                  <div class="item-image">
                    <el-image :src="item.imgUrl" fit="cover" class="image">
                      <div slot="error" class="image-error">
                        <i class="el-icon-picture-outline"></i>
                        <span>暂无图片</span>
                      </div>
                    </el-image>
                    <div v-if="activeName==='4'||activeName==='5'" class="order-status-tag">
                      <el-tag :type="getOrderStatusType(item.orderStatus)" size="small">
                        {{orderStatus[item.orderStatus]}}
                      </el-tag>
                    </div>
                  </div>
                  <div class="item-content">
                    <h3 class="item-title">{{item.idleName}}</h3>
                    <p class="item-desc">{{item.idleDetails}}</p>
                    <div class="item-meta">
                      <span class="item-price">¥{{item.idlePrice}}</span>
                      <span class="item-time">{{item.timeStr}}</span>
                    </div>
                    <div class="item-actions" v-if="activeName!=='4'&&activeName!=='5'">
                      <el-button
                          type="danger"
                          size="mini"
                          plain
                          @click.stop="handle(activeName,item,index)"
                          class="action-btn">
                        {{handleName[activeName-1]}}
                      </el-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 地址管理页面 -->
      <div v-show="eidtAddress" class="address-container">
        <el-card class="address-card" shadow="never">
          <div slot="header" class="address-header">
            <el-page-header @back="eidtAddress=false" content="收货地址管理"></el-page-header>
          </div>

          <!-- 新增地址表单 -->
          <el-card shadow="never" class="address-form-card">
            <div slot="header" class="form-header">
              <span><i class="el-icon-plus"></i> 新增收货地址</span>
              <span class="address-limit">最多添加5个地址</span>
            </div>

            <el-form :model="addressInfo" label-width="100px" class="address-form">
              <el-row :gutter="20">
                <el-col :xs="24" :sm="12">
                  <el-form-item label="收货人">
                    <el-input
                        v-model="addressInfo.consigneeName"
                        placeholder="请输入收货人姓名"
                        prefix-icon="el-icon-user"
                        maxlength="10"
                        show-word-limit>
                    </el-input>
                  </el-form-item>
                </el-col>
                <el-col :xs="24" :sm="12">
                  <el-form-item label="手机号">
                    <el-input
                        v-model="addressInfo.consigneePhone"
                        placeholder="请输入收货人手机号"
                        prefix-icon="el-icon-mobile-phone"
                        maxlength="11"
                        show-word-limit>
                    </el-input>
                  </el-form-item>
                </el-col>
              </el-row>

              <el-form-item label="宿舍区域">
                <el-cascader
                    v-model="selectedOptions"
                    :options="options"
                    placeholder="请选择宿舍类型/楼号/楼层"
                    @change="handleAddressChange"
                    style="width: 100%"
                    :separator="' '">
                </el-cascader>
              </el-form-item>

              <el-form-item label="详细地址">
                <el-input
                    type="textarea"
                    :rows="2"
                    v-model="addressInfo.detailAddress"
                    placeholder="宿舍号 + 放到哪里"
                    maxlength="50"
                    show-word-limit>
                </el-input>
              </el-form-item>

              <el-form-item>
                <el-checkbox v-model="addressInfo.defaultFlag">
                  设为默认地址
                </el-checkbox>
              </el-form-item>

              <el-form-item class="form-actions">
                <el-button type="primary" icon="el-icon-check" @click="saveAddress">
                  保存地址
                </el-button>
                <el-button icon="el-icon-refresh" @click="resetAddressForm">
                  重置
                </el-button>
              </el-form-item>
            </el-form>
          </el-card>

          <!-- 地址列表 -->
          <div class="address-list">
            <div class="list-header">
              <i class="el-icon-location"></i>
              已保存的地址
              <span class="address-count">共 {{addressData.length}} 个</span>
            </div>

            <div v-if="addressData.length === 0" class="empty-address">
              <i class="el-icon-map-location"></i>
              <p>您还没有添加任何收货地址</p>
            </div>

            <el-row :gutter="20" v-else>
              <el-col :xs="24" :sm="12" :lg="8" v-for="(address, index) in addressData" :key="index">
                <el-card
                    class="address-item"
                    :class="{'default-address': address.defaultFlag}"
                    shadow="hover">
                  <div class="address-item-header">
                    <div class="address-info">
                      <span class="address-name">{{address.consigneeName}}</span>
                      <span class="address-phone">{{address.consigneePhone}}</span>
                    </div>
                    <el-tag v-if="address.defaultFlag" type="success" size="small">默认</el-tag>
                  </div>

                  <div class="address-content">
                    <i class="el-icon-location-information"></i>
                    <span class="address-detail">{{address.detailAddressText}}</span>
                  </div>

                  <div class="address-actions">
                    <el-button
                        size="mini"
                        type="primary"
                        plain
                        icon="el-icon-edit"
                        @click="handleEdit(index, address)">
                      编辑
                    </el-button>
                    <el-button
                        v-if="!address.defaultFlag"
                        size="mini"
                        type="success"
                        plain
                        icon="el-icon-star-off"
                        @click="handleSetDefault(index, address)">
                      设为默认
                    </el-button>
                    <el-button
                        size="mini"
                        type="danger"
                        plain
                        icon="el-icon-delete"
                        @click="handleDelete(index, address)">
                      删除
                    </el-button>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </div>
        </el-card>
      </div>
      <app-foot></app-foot>
    </app-body>
  </div>
</template>

<script>
import AppHead from '../common/AppHeader.vue';
import AppBody from '../common/AppPageBody.vue'
import AppFoot from '../common/AppFoot.vue'
import options from '../common/country-data.js'

export default {
  name: "me",
  components: {
    AppHead,
    AppBody,
    AppFoot
  },
  data() {
    return {
      imgFileList: [],
      addressInfo: {
        consigneeName: '',
        consigneePhone: '',
        provinceName: '',
        cityName: '',
        regionName: '',
        detailAddress: '',
        defaultFlag: false
      },
      activeName: '1',
      handleName: ['下架', '删除', '取消收藏', '', ''],
      dataList: [[], [], [], [], [], [], [], []],
      orderStatus: ['待付款', '待发货', '待收货', '已完成', '已取消'],
      userInfoDialogVisible: false,
      notUserNicknameEdit: true,
      userPasswordEdit: false,
      userPassword1: '',
      userPassword2: '',
      userPassword3: '',
      eidtAddress: false,
      selectedOptions: [],
      options: options,
      userInfo: {
        accountNumber: "",
        avatar: "",
        nickname: "",
        signInTime: "",
      },
      addressData: []
    };
  },
  created() {
    if (!this.$globalData.userInfo.nickname) {
      this.$api.getUserInfo().then(res => {
        if (res.status_code === 1) {
          res.data.signInTime = res.data.signInTime.substring(0, 10);
          this.$globalData.userInfo = res.data;
          this.userInfo = this.$globalData.userInfo;
        }
      })
    } else {
      this.userInfo = this.$globalData.userInfo;
    }
    this.getAddressData();
    this.getIdleItemData();
    this.getMyOrder();
    this.getMySoldIdle();
    this.getMyFavorite();
  },
  methods: {
    getOrderStatusType(status) {
      const types = ['warning', 'primary', 'success', 'info', 'danger'];
      return types[status] || 'info';
    },
    getEmptyIcon(tabName) {
      const icons = {
        '1': 'el-icon-upload',
        '2': 'el-icon-download',
        '3': 'el-icon-shopping-cart-full',
        '4': 'el-icon-sold-out',
        '5': 'el-icon-shopping-bag-1'
      };
      return icons[tabName] || 'el-icon-document';
    },
    getEmptyText(tabName) {
      const texts = {
        '1': '您还没有发布任何商品',
        '2': '没有已下架的商品',
        '3': '您的收藏是空的',
        '4': '您还没有出售记录',
        '5': '您还没有购买记录'
      };
      return texts[tabName] || '暂无数据';
    },
    // ... 其他方法保持不变
    getMyFavorite(){
      this.$api.getMyFavorite().then(res=>{
        console.log('getMyFavorite',res);
        if (res.status_code === 1){
          for (let i = 0; i < res.data.length; i++) {
            let pictureList = JSON.parse(res.data[i].idleItem.pictureList);
            this.dataList[2].push({
              favoriteId:res.data[i].id,
              id:res.data[i].idleItem.id,
              imgUrl:pictureList.length > 0 ? pictureList[0] : '',
              idleName:res.data[i].idleItem.idleName,
              idleDetails:res.data[i].idleItem.idleDetails,
              timeStr:res.data[i].createTime.substring(0, 10) + " " + res.data[i].createTime.substring(11, 19),
              idlePrice:res.data[i].idleItem.idlePrice
            });
          }
        }
      })
    },
    getMySoldIdle(){
      this.$api.getMySoldIdle().then(res=>{
        if (res.status_code === 1){
          console.log('getMySoldIdle',res.data);
          for (let i = 0; i < res.data.length; i++) {
            let pictureList = JSON.parse(res.data[i].idleItem.pictureList);
            this.dataList[3].push({
              id:res.data[i].id,
              imgUrl:pictureList.length > 0 ? pictureList[0] : '',
              idleName:res.data[i].idleItem.idleName,
              idleDetails:res.data[i].idleItem.idleDetails,
              timeStr:res.data[i].createTime.substring(0, 10) + " " + res.data[i].createTime.substring(11, 19),
              idlePrice:res.data[i].orderPrice,
              orderStatus:res.data[i].orderStatus
            });
          }
        }
      })
    },
    getMyOrder(){
      this.$api.getMyOrder().then(res=>{
        if (res.status_code === 1){
          console.log('getMyOrder',res.data);
          for (let i = 0; i < res.data.length; i++) {
            let pictureList = JSON.parse(res.data[i].idleItem.pictureList);
            this.dataList[4].push({
              id:res.data[i].id,
              imgUrl:pictureList.length > 0 ? pictureList[0] : '',
              idleName:res.data[i].idleItem.idleName,
              idleDetails:res.data[i].idleItem.idleDetails,
              timeStr:res.data[i].createTime.substring(0, 10) + " " + res.data[i].createTime.substring(11, 19),
              idlePrice:res.data[i].orderPrice,
              orderStatus:res.data[i].orderStatus
            });
          }
        }
      })
    },
    getIdleItemData() {
      this.$api.getAllIdleItem().then(res => {
        console.log(res);
        if (res.status_code === 1) {
          for (let i = 0; i < res.data.length; i++) {
            res.data[i].timeStr = res.data[i].releaseTime.substring(0, 10) + " " + res.data[i].releaseTime.substring(11, 19);
            let pictureList = JSON.parse(res.data[i].pictureList);
            res.data[i].imgUrl = pictureList.length > 0 ? pictureList[0] : '';
            if (res.data[i].idleStatus === 1) {
              this.dataList[0].push(res.data[i]);
            } else if (res.data[i].idleStatus === 2) {
              this.dataList[1].push(res.data[i]);
            }
          }
        }
      })
    },
    getAddressData() {
      this.$api.getAddress().then(res => {
        if (res.status_code === 1) {
          let data = res.data;
          for (let i = 0; i < data.length; i++) {
            data[i].detailAddressText = data[i].provinceName + data[i].cityName + data[i].regionName + data[i].detailAddress;
            data[i].defaultAddress = data[i].defaultFlag ? '默认地址' : '设为默认';
          }
          console.log(data);
          this.addressData = data;
        }
      })
    },
    handleClick(tab, event) {
      console.log(this.activeName);
    },
    saveUserNickname() {
      this.notUserNicknameEdit = true;
      this.$api.updateUserPublicInfo({
        nickname: this.userInfo.nickname
      }).then(res => {
        console.log(res);
        this.$globalData.userInfo.nickname = this.userInfo.nickname;
      })
    },
    savePassword() {
      if (!this.userPassword1 || !this.userPassword2) {
        this.$message.error('密码为空！');
      } else if (this.userPassword2 === this.userPassword3) {
        this.$api.updatePassword({
          oldPassword: this.userPassword1,
          newPassword: this.userPassword2
        }).then(res => {
          if (res.status_code === 1) {
            this.userPasswordEdit = false;
            this.$message({
              message: '修改成功！',
              type: 'success'
            });
            this.userPassword1 = '';
            this.userPassword2 = '';
            this.userPassword3 = '';
          } else {
            this.$message.error('旧密码错误，修改失败！');
          }
        })
      } else {
        this.$message.error('两次输入的密码不一致！');
      }
    },
    finishEdit() {
      this.notUserNicknameEdit = true;
      this.userInfoDialogVisible = false;
      this.userPasswordEdit = false;
    },
    handleAddressChange(value) {
      console.log(value);
      this.addressInfo.provinceName = value[0];
      this.addressInfo.cityName = value[1];
      this.addressInfo.regionName = value[2];
    },
    handleEdit(index, row) {
      console.log(index, row);
      this.addressInfo = JSON.parse(JSON.stringify(row));
      this.selectedOptions = ['', '', ''];
      this.selectedOptions[0] = row.provinceName;
      this.selectedOptions[1] = row.cityName;
      this.selectedOptions[2] = row.regionName;
    },
    handleDelete(index, row) {
      console.log(index, row);
      this.$confirm('是否确定删除该地址?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$api.deleteAddress(row).then(res => {
          if (res.status_code === 1) {
            this.$message({
              message: '删除成功！',
              type: 'success'
            });
            this.addressData.splice(index, 1);
            if (row.defaultFlag && this.addressData.length > 0) {
              this.addressData[0].defaultFlag = true;
              this.addressData[0].defaultAddress = '默认地址';
              this.update({
                id: this.addressData[0].id,
                defaultFlag: true
              });
            }
          } else {
            this.$message.error('系统异常，删除失败！')
          }
        }).catch(() => {
          this.$message.error('网络异常！')
        });
      }).catch(() => {
      });
    },
    handleSetDefault(index, row) {
      console.log(index, row);
      row.defaultFlag = true;
      this.update(row);
    },
    toDetails(activeName, item) {
      if (activeName === '4'||activeName === '5') {
        this.$router.push({path: '/order', query: {id: item.id}});
      } else {
        this.$router.push({path: '/details', query: {id: item.id}});
      }
    },
    handle(activeName,item,index) {
      console.log(activeName,item,index);
      this.$confirm('是否确认？', '提示', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        if(activeName==='1'){
          this.$api.updateIdleItem({
            id:item.id,
            idleStatus:2
          }).then(res=>{
            console.log(res);
            if(res.status_code===1){
              this.dataList[0].splice(index,1);
              item.idleStatus=2;
              this.dataList[1].unshift(item);
            }else {
              this.$message.error(res.msg)
            }
          });
        }else if(activeName==='2'){
          this.$api.updateIdleItem({
            id:item.id,
            idleStatus:0
          }).then(res=>{
            console.log(res);
            if(res.status_code===1){
              this.dataList[1].splice(index,1);
            }else {
              this.$message.error(res.msg)
            }
          });
        }else if(activeName==='3'){
          this.$api.deleteFavorite({
            id: item.favoriteId
          }).then(res=>{
            console.log(res);
            if(res.status_code===1){
              this.$message({
                message: '已取消收藏！',
                type: 'success'
              });
              this.dataList[2].splice(index,1);
            }else {
              this.$message.error(res.msg)
            }
          }).catch(e=>{
          })
        }
      }).catch(() => {
      });
    },
    fileHandleSuccess(response, file, fileList) {
      console.log("file:", response, file, fileList);
      let imgUrl = response.data;
      this.imgFileList = [];
      this.$api.updateUserPublicInfo({
        avatar: imgUrl
      }).then(res => {
        console.log(res);
        this.userInfo.avatar = imgUrl;
        this.$globalData.userInfo.avatar = imgUrl;
      })
    },
    update(data) {
      this.$api.updateAddress(data).then(res => {
        if (res.status_code === 1) {
          this.getAddressData();
          this.$message({
            message: '修改成功！',
            type: 'success'
          });
        } else {
          this.$message.error('系统异常，修改失败！')
        }
      }).catch(() => {
        this.$message.error('网络异常！')
      })
    },
    saveAddress() {
      if (this.addressInfo.id) {
        console.log('update:', this.addressInfo);
        this.update(this.addressInfo);
        this.addressInfo = {
          consigneeName: '',
          consigneePhone: '',
          provinceName: '',
          cityName: '',
          regionName: '',
          detailAddress: '',
          defaultFlag: false
        };
        this.selectedOptions = [];
      } else {
        if (this.addressData.length >= 5) {
          this.$message.error('已达到最大地址数量！')
        } else {
          console.log(this.addressInfo);
          this.$api.addAddress(this.addressInfo).then(res => {
            if (res.status_code === 1) {
              this.getAddressData();
              this.$message({
                message: '新增成功！',
                type: 'success'
              });
              this.selectedOptions = [];
              this.addressInfo = {
                consigneeName: '',
                consigneePhone: '',
                provinceName: '',
                cityName: '',
                regionName: '',
                detailAddress: '',
                defaultFlag: false
              };
            } else {
              this.$message.error('系统异常，新增失败！')
            }
          }).catch(e => {
            this.$message.error('网络异常！')
          })
        }
      }
    },
    resetAddressForm() {
      this.addressInfo = {
        consigneeName: '',
        consigneePhone: '',
        provinceName: '',
        cityName: '',
        regionName: '',
        detailAddress: '',
        defaultFlag: false
      };
      this.selectedOptions = [];
    }
  }
}
</script>

<style scoped>
.profile-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  background: #f8f9fa;
}

/* 用户信息卡片样式 */
.user-profile-card {
  margin-bottom: 24px;
  border-radius: 16px;
  border: none;
  background: linear-gradient(135deg, #667eea 0%, #00c9a7 100%);
  color: white;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.user-profile-card >>> .el-card__body {
  padding: 40px;
}

.user-info-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.user-avatar-section {
  display: flex;
  align-items: center;
  gap: 24px;
}

.avatar-wrapper {
  position: relative;
  cursor: pointer;
  border-radius: 50%;
  overflow: hidden;
  transition: all 0.3s ease;
}

.avatar-wrapper:hover {
  transform: scale(1.05);
}

.avatar-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
  border-radius: 50%;
  color: white;
  font-size: 12px;
}

.avatar-wrapper:hover .avatar-overlay {
  opacity: 1;
}

.avatar-overlay i {
  font-size: 20px;
  margin-bottom: 4px;
}

.user-avatar {
  border: 4px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.user-basic-info {
  color: white;
}

.user-nickname {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 8px 0;
}

.user-join-time {
  margin: 0 0 24px 0;
  opacity: 0.9;
  font-size: 14px;
}

.user-join-time i {
  margin-right: 8px;
}

.user-stats {
  display: flex;
  gap: 40px;
}

.stat-item {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 13px;
  opacity: 0.8;
}

.user-actions {
  display: flex;
  gap: 12px;
}

.user-actions .el-button {
  padding: 12px 24px;
  font-weight: 500;
  border: 2px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.user-actions .el-button:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

/* 编辑表单样式 */
.edit-form {
  padding: 20px 0;
}

.form-group {
  margin-bottom: 24px;
}

.form-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #303133;
  font-size: 14px;
}

.input-with-action {
  display: flex;
  gap: 12px;
}

.edit-toggle-btn {
  flex-shrink: 0;
  min-width: 80px;
}

.password-edit-group {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.password-input {
  margin-bottom: 0;
}

.password-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 8px;
}

/* 内容标签页样式 */
.user-content-card {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.content-tabs {
  padding: 0;
}

.custom-tabs >>> .el-tabs__header {
  margin: 0;
  background: white;
  border-radius: 16px 16px 0 0;
  padding: 0 24px;
}

.custom-tabs >>> .el-tabs__nav-wrap::after {
  display: none;
}

.custom-tabs >>> .el-tabs__item {
  height: 60px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.custom-tabs >>> .el-tabs__item.is-active {
  color: #409EFF;
  font-weight: 600;
}

.custom-tabs >>> .el-tabs__active-bar {
  background-color: #409EFF;
}

.tab-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
}

.tab-icon {
  font-size: 18px;
}

.tab-badge {
  margin-left: 4px;
}

/* 商品列表样式 */
.item-list {
  padding: 24px;
  min-height: 400px;
}

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: #909399;
}

.empty-icon {
  font-size: 80px;
  color: #e1e5e9;
  margin-bottom: 20px;
  opacity: 0.6;
}

.empty-text {
  font-size: 16px;
  margin-bottom: 20px;
  color: #606266;
}

.empty-action {
  margin-top: 20px;
}

.item-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.item-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #f0f0f0;
}

.item-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

.item-image {
  position: relative;
  height: 160px;
  overflow: hidden;
}

.image {
  width: 100%;
  height: 100%;
  transition: transform 0.3s ease;
}

.item-card:hover .image {
  transform: scale(1.05);
}

.image-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  background: #f8f9fa;
  color: #909399;
  font-size: 14px;
}

.image-error i {
  font-size: 32px;
  margin-bottom: 8px;
  opacity: 0.5;
}

.order-status-tag {
  position: absolute;
  top: 10px;
  right: 10px;
}

.item-content {
  padding: 16px;
}

.item-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 8px 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.item-desc {
  font-size: 13px;
  color: #606266;
  margin: 0 0 12px 0;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.item-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.item-price {
  font-size: 18px;
  font-weight: 700;
  color: #f56c6c;
}

.item-time {
  font-size: 12px;
  color: #909399;
}

.item-actions {
  display: flex;
  justify-content: flex-end;
}

.action-btn {
  font-weight: 500;
  padding: 6px 12px;
}

/* 地址管理样式 */
.address-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  background: #f8f9fa;
}

.address-card {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.address-header {
  padding: 20px 24px;
  border-bottom: 1px solid #f0f0f0;
  font-weight: 600;
  font-size: 18px;
}

.address-form-card {
  margin-bottom: 30px;
  border: 1px solid #e6e8eb;
  border-radius: 12px;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  font-size: 16px;
}

.address-limit {
  font-size: 12px;
  color: #909399;
}

.address-form {
  padding: 20px;
}

.form-actions {
  margin-top: 20px;
  text-align: right;
}

.address-list {
  margin-top: 30px;
}

.list-header {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.list-header i {
  color: #409EFF;
}

.address-count {
  font-size: 14px;
  color: #909399;
  font-weight: normal;
  margin-left: auto;
}

.empty-address {
  text-align: center;
  padding: 80px 20px;
  color: #909399;
}

.empty-address i {
  font-size: 80px;
  color: #e1e5e9;
  margin-bottom: 16px;
  opacity: 0.6;
}

.address-item {
  margin-bottom: 20px;
  transition: all 0.3s ease;
  border: 1px solid #e6e8eb;
  border-radius: 12px;
}

.address-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
}

.default-address {
  border-color: #67c23a;
  background: linear-gradient(135deg, #f0f9ff 0%, #e6f7ff 100%);
}

.address-item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding: 16px 16px 0;
}

.address-info {
  display: flex;
  gap: 16px;
  align-items: center;
}

.address-name {
  font-weight: 600;
  color: #303133;
  font-size: 16px;
}

.address-phone {
  color: #606266;
  font-size: 14px;
}

.address-content {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  margin-bottom: 16px;
  padding: 0 16px;
}

.address-content i {
  color: #409EFF;
  margin-top: 2px;
  flex-shrink: 0;
  font-size: 16px;
}

.address-detail {
  color: #606266;
  line-height: 1.5;
  word-break: break-all;
  font-size: 14px;
}

.address-actions {
  display: flex;
  gap: 8px;
  justify-content: flex-end;
  padding: 0 16px 16px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .profile-container,
  .address-container {
    padding: 16px;
  }

  .user-info-container {
    flex-direction: column;
    gap: 24px;
    text-align: center;
  }

  .user-avatar-section {
    flex-direction: column;
    text-align: center;
  }

  .user-stats {
    justify-content: center;
    gap: 30px;
  }

  .user-actions {
    justify-content: center;
    flex-wrap: wrap;
  }

  .item-grid {
    grid-template-columns: 1fr;
  }

  .input-with-action {
    flex-direction: column;
  }

  .address-item-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .address-actions {
    justify-content: flex-start;
    flex-wrap: wrap;
  }

  .user-nickname {
    font-size: 24px;
  }

  .stat-number {
    font-size: 24px;
  }
}

@media (max-width: 480px) {
  .user-stats {
    gap: 20px;
  }

  .stat-number {
    font-size: 20px;
  }

  .user-actions {
    flex-direction: column;
    width: 100%;
  }

  .user-actions .el-button {
    width: 100%;
  }

  .address-form {
    padding: 16px;
  }
}
</style>
