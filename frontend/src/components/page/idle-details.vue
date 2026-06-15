<template>
  <div>
    <app-head></app-head>
    <app-body>
      <div class="idle-details-container">
        <!-- 商品详情卡片 -->
        <el-card class="product-card" shadow="never">
          <!-- 用户信息与价格区域 -->
          <div class="details-header">
            <div class="details-header-user-info">
              <div class="user-avatar-wrapper">
                <el-avatar
                    :size="80"
                    :src="idleItemInfo.user.avatar"
                    class="user-avatar">
                </el-avatar>
                <div class="user-online-indicator"></div>
              </div>
              <div class="user-info-text">
                <div class="details-header-user-info-nickname">{{idleItemInfo.user.nickname}}</div>
                <div class="details-header-user-info-time">
                  <i class="el-icon-time"></i> {{idleItemInfo.user.signInTime.substring(0,10)}} 加入平台
                </div>
                <div class="user-trust-score">
                  <el-rate
                      v-model="trustScore"
                      disabled
                      show-score
                      text-color="#ff9900"
                      score-template="{value} 信用分">
                  </el-rate>
                </div>
              </div>
            </div>
            <div class="details-header-buy" :class="{'owner-controls': isMaster}">
              <div v-show="idleItemInfo.idlePrice !== 0" class="product-price">
                <span class="price-symbol">¥</span>{{idleItemInfo.idlePrice}}
              </div>
              <div v-if="!isMaster && idleItemInfo.idleStatus!==1" class="product-status">
                <i class="el-icon-warning-outline"></i> 闲置已下架或删除
              </div>
              <div class="action-buttons">
                <el-button
                    v-show="idleItemInfo.idlePrice > 0"
                    v-if="!isMaster && idleItemInfo.idleStatus===1"
                    type="danger"
                    icon="el-icon-shopping-cart-2"
                    round
                    class="buy-btn"
                    @click="buyButton(idleItemInfo)">
                  立即购买
                </el-button>
                <el-button
                    v-show="idleItemInfo.idlePrice > 0"
                    v-if="!isMaster && idleItemInfo.idleStatus===1"
                    :type="isFavorite ? 'warning' : 'primary'"
                    :icon="isFavorite ? 'el-icon-star-on' : 'el-icon-star-off'"
                    round
                    class="favorite-btn"
                    @click="favoriteButton(idleItemInfo)">
                  {{isFavorite ? '取消收藏' : '加入收藏'}}
                </el-button>
                <el-button
                    v-if="isMaster && idleItemInfo.idleStatus===1"
                    type="danger"
                    icon="el-icon-download"
                    round
                    class="offline-btn"
                    @click="changeStatus(idleItemInfo,2)">
                  下架
                </el-button>
                <el-button
                    v-if="isMaster && idleItemInfo.idleStatus===2"
                    type="success"
                    icon="el-icon-upload2"
                    round
                    class="online-btn"
                    @click="changeStatus(idleItemInfo,1)">
                  重新上架
                </el-button>
              </div>
            </div>
          </div>

          <!-- 分隔线 -->
          <el-divider class="custom-divider"></el-divider>

          <!-- 商品详情区域 -->
          <div class="details-info">
            <div class="details-info-title">
              <span class="product-name">{{idleItemInfo.idleName}}</span>
              <el-tag
                  v-if="idleItemInfo.idleLabel"
                  :type="getTagType(idleItemInfo.idleLabel)"
                  size="medium"
                  class="product-tag"
                  effect="light">
                {{getCategoryName(idleItemInfo.idleLabel)}}
              </el-tag>
            </div>

            <div class="product-meta-info">
              <div class="product-location" v-if="idleItemInfo.idlePlace">
                <i class="el-icon-location"></i> {{idleItemInfo.idlePlace}}
              </div>
              <div class="product-time">
                <i class="el-icon-time"></i> {{idleItemInfo.timeStr || '刚刚发布'}}
              </div>
            </div>

            <div class="details-info-main" v-html="idleItemInfo.idleDetails">
              {{idleItemInfo.idleDetails}}
            </div>
          </div>

          <!-- 商品图片区域 -->
          <div class="details-picture">
            <div v-if="idleItemInfo.pictureList && idleItemInfo.pictureList.length > 0" class="image-gallery">
              <div class="main-image">
                <el-image
                    :src="currentImage"
                    fit="contain"
                    class="gallery-main-image"
                    :preview-src-list="idleItemInfo.pictureList">
                </el-image>
              </div>
              <div class="thumbnail-list" v-if="idleItemInfo.pictureList.length > 1">
                <div
                    v-for="(imgUrl, i) in idleItemInfo.pictureList"
                    :key="i"
                    :class="['thumbnail-item', { active: currentImage === imgUrl }]"
                    @click="currentImage = imgUrl">
                  <el-image
                      :src="imgUrl"
                      fit="cover"
                      class="thumbnail-image">
                  </el-image>
                </div>
              </div>
            </div>

            <div v-else class="no-images">
              <div class="no-images-content">
                <i class="el-icon-picture-outline"></i>
                <p>暂无图片</p>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 留言板区域 -->
        <el-card class="message-card" shadow="never" id="replyMessageLocation">
          <div slot="header" class="message-header">
            <span class="message-title"><i class="el-icon-chat-line-round"></i> 留言板</span>
            <el-badge :value="messageList.length" :max="99" class="message-badge" type="primary"/>
          </div>

          <!-- 发送留言区域 -->
          <div class="message-send">
            <div v-if="isReply" class="reply-info">
              <el-tag type="info" closable @close="cancelReply" class="reply-tag">
                <i class="el-icon-chat-line-square"></i>
                回复：{{replyData.toMessage}} @{{replyData.toUserNickname}}
              </el-tag>
            </div>
            <el-input
                type="textarea"
                :rows="4"
                placeholder="在此留言提问..."
                v-model="messageContent"
                maxlength="200"
                show-word-limit
                resize="none"
                class="message-input">
            </el-input>
            <div class="message-send-button">
              <el-button type="primary" icon="el-icon-s-promotion" @click="sendMessage" round class="send-btn">发送留言</el-button>
            </div>
          </div>

          <!-- 留言列表 -->
          <div class="message-list">
            <div v-if="messageList.length === 0" class="no-messages">
              <div class="no-messages-content">
                <i class="el-icon-chat-dot-square"></i>
                <p>暂无留言，快来留言吧!</p>
                <p class="no-messages-hint">成为第一个留言的人</p>
              </div>
            </div>

            <div v-else class="message-timeline">
              <div
                  v-for="(mes, index) in messageList"
                  :key="index"
                  class="message-item">
                <div class="message-avatar-wrapper">
                  <el-avatar
                      :size="48"
                      :src="mes.fromU.avatar"
                      class="message-avatar">
                  </el-avatar>
                </div>
                <div class="message-content-wrapper">
                  <div class="message-header-info">
                    <span class="message-nickname">{{mes.fromU.nickname}}</span>
                    <span class="message-time">{{mes.createTime}}</span>
                  </div>
                  <div v-if="mes.toU.nickname" class="reply-preview">
                    <i class="el-icon-chat-line-round"></i>
                    回复 <strong>@{{mes.toU.nickname}}</strong>：
                    <span class="quoted-message">{{mes.toM.content.substring(0,15)}}{{mes.toM.content.length>15?'...':''}}</span>
                  </div>
                  <div class="message-content" v-html="mes.content">{{mes.content}}</div>
                  <div class="message-actions">
                    <el-button type="text" icon="el-icon-chat-dot-round" @click="replyMessage(index)" class="reply-btn">回复</el-button>
                  </div>
                </div>
              </div>
            </div>
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

export default {
  name: "idle-details",
  components: {
    AppHead,
    AppBody,
    AppFoot
  },
  data() {
    return {
      messageContent:'',
      toUser:null,
      toMessage:null,
      isReply:false,
      replyData:{
        toUserNickname:'',
        toMessage:''
      },
      messageList:[],
      idleItemInfo:{
        id:'',
        idleName:'',
        idleDetails:'',
        pictureList:[],
        idlePrice:0,
        idlePlace:'',
        idleLabel:'',
        idleStatus:-1,
        userId:'',
        user:{
          avatar:'',
          nickname:'',
          signInTime:''
        },
      },
      isMaster:false,
      isFavorite:true,
      favoriteId:0,
      trustScore: 4.5,
      currentImage: '',
      categories: {
        '1': '软件工程',
        '2': '外语系',
        '3': '动画',
        '4': '电子信息',
        '5': '公告'
      }
    };
  },
  created(){
    let id=this.$route.query.id;
    this.$api.getIdleItem({
      id:id
    }).then(res=>{
      console.log(res);
      if(res.data){
        let list=res.data.idleDetails.split(/\r?\n/);
        let str='';
        for(let i=0;i<list.length;i++){
          str+='<p>'+list[i]+'</p>';
        }
        res.data.idleDetails=str;
        res.data.pictureList=JSON.parse(res.data.pictureList);
        this.idleItemInfo=res.data;
        // 设置默认显示图片
        if (res.data.pictureList && res.data.pictureList.length > 0) {
          this.currentImage = res.data.pictureList[0];
        }
        console.log(this.idleItemInfo);
        let userId=this.getCookie('shUserId');
        console.log('userid',userId)
        if(userId == this.idleItemInfo.userId){
          console.log('isMaster');
          this.isMaster=true;
        }
        this.checkFavorite();
        this.getAllIdleMessage();
      }
      $('html,body').animate({
        scrollTop: 0
      }, {duration: 500, easing: "swing"});
    });
  },
  methods: {
    getCategoryName(label) {
      return this.categories[label] || '其他';
    },
    getTagType(label) {
      const types = {
        '1': 'primary',
        '2': 'success',
        '3': 'warning',
        '4': 'info',
        '5': 'danger'
      };
      return types[label] || 'info';
    },
    getAllIdleMessage(){
      this.$api.getAllIdleMessage({
        idleId:this.idleItemInfo.id
      }).then(res=>{
        console.log('getAllIdleMessage',res.data);
        if(res.status_code===1){
          this.messageList=res.data;
        }
      }).catch(()=>{
      })
    },
    checkFavorite(){
      this.$api.checkFavorite({
        idleId:this.idleItemInfo.id
      }).then(res=>{
        if(!res.data){
          this.isFavorite=false;
        }else {
          this.favoriteId=res.data;
        }
      })
    },
    getCookie(cname){
      var name = cname + "=";
      var ca = document.cookie.split(';');
      for(var i=0; i<ca.length; i++)
      {
        var c = ca[i].trim();
        if (c.indexOf(name)===0) return c.substring(name.length,c.length);
      }
      return "";
    },
    replyMessage(index){
      $('html,body').animate({
        scrollTop: $("#replyMessageLocation").offset().top-100
      }, {duration: 500, easing: "swing"});
      this.isReply=true;
      this.replyData.toUserNickname=this.messageList[index].fromU.nickname;
      this.replyData.toMessage=this.messageList[index].content.substring(0,10)+(this.messageList[index].content.length>10?'...':'');
      this.toUser=this.messageList[index].userId;
      this.toMessage=this.messageList[index].id;
    },
    changeStatus(idle,status){
      this.$api.updateIdleItem({
        id:idle.id,
        idleStatus:status
      }).then(res=>{
        console.log(res);
        if(res.status_code===1){
          this.idleItemInfo.idleStatus=status;
          this.$message({
            message: status === 1 ? '商品已重新上架' : '商品已下架',
            type: 'success'
          });
        }else {
          this.$message.error(res.msg)
        }
      });
    },
    buyButton(idleItemInfo){
      this.$api.addOrder({
        idleId:idleItemInfo.id,
        orderPrice:idleItemInfo.idlePrice,
      }).then(res=>{
        console.log(res);
        if(res.status_code===1){
          this.$router.push({path: '/order', query: {id: res.data.id}});
        }else {
          this.$message.error(res.msg)
        }
      }).catch(e=>{

      })
    },
    favoriteButton(idleItemInfo){
      if(this.isFavorite){
        this.$api.deleteFavorite({
          id: this.favoriteId
        }).then(res=>{
          console.log(res);
          if(res.status_code===1){
            this.$message({
              message: '已取消收藏！',
              type: 'success'
            });
            this.isFavorite=false;
          }else {
            this.$message.error(res.msg)
          }
        }).catch(e=>{
        })
      }else {
        this.$api.addFavorite({
          idleId:idleItemInfo.id
        }).then(res=>{
          console.log(res);
          if(res.status_code===1){
            this.$message({
              message: '已加入收藏！',
              type: 'success'
            });
            this.isFavorite=true;
            this.favoriteId=res.data;
          }else {
            this.$message.error(res.msg)
          }
        }).catch(e=>{
        })
      }
    },
    cancelReply(){
      this.isReply=false;
      this.toUser=this.idleItemInfo.userId;
      this.toMessage=null;
      this.replyData.toUserNickname='';
      this.replyData.toMessage='';
    },
    sendMessage(){
      let content=this.messageContent.trim();
      if(this.toUser==null){
        this.toUser=this.idleItemInfo.userId;
      }
      if(content){
        let contentList=content.split(/\r?\n/);
        let contenHtml=contentList[0];
        for(let i=1;i<contentList.length;i++){
          contenHtml+='<br>'+contentList[i];
        }
        this.$api.sendMessage({
          idleId:this.idleItemInfo.id,
          content:contenHtml,
          toUser:this.toUser,
          toMessage:this.toMessage
        }).then(res=>{
          if(res.status_code===1){
            this.$message({
              message: '留言成功！',
              type: 'success'
            });
            this.messageContent='';
            this.cancelReply();
            this.getAllIdleMessage();
          }else {
            this.$message.error("留言失败！"+res.msg);
          }
        }).catch(()=>{
          this.$message.error("留言失败！");
        });

      }else{
        this.$message.error("留言为空！");
      }
    }
  },
}
</script>

<style scoped>
.idle-details-container {
  min-height: 85vh;
  padding: 20px 0;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
}

/* 商品卡片样式 */
.product-card, .message-card {
  margin-bottom: 24px;
  border-radius: 16px;
  overflow: hidden;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.product-card:hover, .message-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

/* 用户信息与价格区域 */
.details-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 24px;
  flex-wrap: wrap;
  background: linear-gradient(135deg, #667eea 0%, #00c9a7 100%);
  margin: -20px -20px 20px -20px;
  border-radius: 16px 16px 0 0;
  color: white;
}

.details-header-user-info {
  display: flex;
  align-items: flex-start;
}

.user-avatar-wrapper {
  position: relative;
  margin-right: 20px;
}

.user-avatar {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  border: 3px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

.user-avatar:hover {
  transform: scale(1.05);
  border-color: rgba(255, 255, 255, 0.6);
}

.user-online-indicator {
  position: absolute;
  bottom: 4px;
  right: 4px;
  width: 16px;
  height: 16px;
  background: #67C23A;
  border: 2px solid white;
  border-radius: 50%;
}

.user-info-text {
  margin-left: 0;
}

.details-header-user-info-nickname {
  font-weight: 700;
  font-size: 20px;
  margin-bottom: 8px;
  color: white;
}

.details-header-user-info-time {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.details-header-user-info-time i {
  margin-right: 6px;
}

.user-trust-score {
  margin-top: 8px;
}

.details-header-buy {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  background: rgba(255, 255, 255, 0.1);
  padding: 20px;
  border-radius: 12px;
  backdrop-filter: blur(10px);
}

.owner-controls {
  align-items: center;
}

.product-price {
  font-size: 32px;
  font-weight: 800;
  color: #ffd666;
  margin-bottom: 16px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.price-symbol {
  font-size: 20px;
  font-weight: 600;
  margin-right: 2px;
}

.product-status {
  color: #ffd666;
  font-size: 16px;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  background: rgba(255, 107, 107, 0.2);
  padding: 8px 16px;
  border-radius: 20px;
}

.product-status i {
  margin-right: 8px;
}

.action-buttons {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.buy-btn, .favorite-btn, .offline-btn, .online-btn, .send-btn {
  font-weight: 600;
  padding: 12px 24px;
  transition: all 0.3s ease;
}

.buy-btn:hover, .favorite-btn:hover, .offline-btn:hover, .online-btn:hover, .send-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 分隔线 */
.custom-divider {
  margin: 0 0 24px 0;
  background: linear-gradient(to right, transparent, #e0e6ed, transparent);
}

/* 商品详情区域 */
.details-info {
  padding: 0 24px 24px;
}

.details-info-title {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 12px;
}

.product-name {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1.3;
}

.product-tag {
  font-weight: 600;
  padding: 6px 16px;
  border-radius: 20px;
}

.product-meta-info {
  display: flex;
  gap: 24px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.product-location, .product-time {
  font-size: 15px;
  color: #606266;
  display: flex;
  align-items: center;
  background: #f8f9fa;
  padding: 8px 16px;
  border-radius: 20px;
}

.product-location i, .product-time i {
  margin-right: 6px;
  color: #409EFF;
}

.details-info-main {
  font-size: 16px;
  color: #606266;
  line-height: 1.8;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 24px;
  border-radius: 12px;
  border-left: 4px solid #409EFF;
}

/* 商品图片区域 */
.details-picture {
  margin: 0 24px 24px;
}

.image-gallery {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 20px;
}

.main-image {
  margin-bottom: 16px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.gallery-main-image {
  height: 400px;
  width: 100%;
  transition: all 0.3s ease;
}

.gallery-main-image:hover {
  transform: scale(1.02);
}

.thumbnail-list {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding: 8px 0;
}

.thumbnail-item {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 3px solid transparent;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.thumbnail-item:hover {
  transform: translateY(-2px);
  border-color: #409EFF;
}

.thumbnail-item.active {
  border-color: #409EFF;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.thumbnail-image {
  width: 100%;
  height: 100%;
}

.no-images {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  height: 300px;
  border-radius: 12px;
  border: 2px dashed #dcdfe6;
}

.no-images-content {
  text-align: center;
  color: #909399;
}

.no-images-content i {
  font-size: 64px;
  margin-bottom: 16px;
  opacity: 0.5;
}

/* 留言板样式 */
.message-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 20px;
  font-weight: 700;
  padding: 20px 24px;
  background: linear-gradient(135deg, #667eea 0%, #00c9a7 100%);
  margin: -20px -20px 20px -20px;
  border-radius: 16px 16px 0 0;
  color: white;
}

.message-title {
  display: flex;
  align-items: center;
}

.message-title i {
  margin-right: 8px;
}

.message-badge {
  margin-left: 10px;
}

.message-send {
  margin-bottom: 30px;
  padding: 0 24px;
}

.reply-info {
  margin-bottom: 16px;
}

.reply-tag {
  padding: 8px 16px;
  border-radius: 20px;
  font-weight: 500;
}

.reply-tag i {
  margin-right: 6px;
}

.message-input {
  margin-bottom: 16px;
}

.message-input >>> .el-textarea__inner {
  border-radius: 12px;
  border: 2px solid #e0e6ed;
  transition: all 0.3s ease;
  font-size: 15px;
}

.message-input >>> .el-textarea__inner:focus {
  border-color: #409EFF;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
}

.message-send-button {
  display: flex;
  justify-content: flex-end;
}

/* 留言列表样式 */
.message-list {
  padding: 0 24px 24px;
}

.no-messages {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 200px;
  color: #909399;
}

.no-messages-content {
  text-align: center;
}

.no-messages-content i {
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.5;
}

.no-messages-hint {
  font-size: 14px;
  opacity: 0.7;
  margin-top: 8px;
}

.message-timeline {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.message-item {
  display: flex;
  gap: 16px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 16px;
  transition: all 0.3s ease;
  border: 1px solid transparent;
}

.message-item:hover {
  background: white;
  border-color: #e0e6ed;
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.message-avatar-wrapper {
  flex-shrink: 0;
}

.message-avatar {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border: 2px solid white;
  transition: all 0.3s ease;
}

.message-item:hover .message-avatar {
  transform: scale(1.1);
  border-color: #409EFF;
}

.message-content-wrapper {
  flex: 1;
}

.message-header-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  flex-wrap: wrap;
  gap: 8px;
}

.message-nickname {
  font-weight: 600;
  font-size: 16px;
  color: #303133;
}

.message-time {
  font-size: 13px;
  color: #909399;
}

.reply-preview {
  font-size: 14px;
  color: #606266;
  background: rgba(64, 158, 255, 0.05);
  padding: 8px 12px;
  border-radius: 8px;
  margin-bottom: 12px;
  border-left: 3px solid #409EFF;
}

.reply-preview i {
  margin-right: 6px;
  color: #409EFF;
}

.quoted-message {
  color: #909399;
  font-style: italic;
}

.message-content {
  font-size: 15px;
  color: #606266;
  line-height: 1.6;
  word-break: break-word;
  margin-bottom: 12px;
}

.message-actions {
  display: flex;
  justify-content: flex-end;
}

.reply-btn {
  color: #409EFF;
  font-weight: 500;
  transition: all 0.3s ease;
}

.reply-btn:hover {
  color: #66b1ff;
  transform: translateX(2px);
}

/* 响应式调整 */
@media (max-width: 768px) {
  .idle-details-container {
    padding: 16px 0;
  }

  .details-header {
    flex-direction: column;
    align-items: flex-start;
    padding: 20px;
  }

  .details-header-buy {
    margin-top: 20px;
    align-items: flex-start;
    width: 100%;
  }

  .action-buttons {
    flex-wrap: wrap;
    margin-top: 10px;
  }

  .product-name {
    font-size: 24px;
  }

  .product-price {
    font-size: 28px;
  }

  .details-info, .details-picture, .message-send, .message-list {
    padding-left: 20px;
    padding-right: 20px;
  }

  .gallery-main-image {
    height: 300px;
  }

  .message-item {
    flex-direction: column;
    text-align: center;
  }

  .message-header-info {
    justify-content: center;
  }

  .message-actions {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .details-header-user-info {
    flex-direction: column;
    text-align: center;
  }

  .user-avatar-wrapper {
    margin-right: 0;
    margin-bottom: 16px;
  }

  .product-meta-info {
    flex-direction: column;
    gap: 12px;
  }

  .action-buttons {
    justify-content: center;
  }

  .buy-btn, .favorite-btn, .offline-btn, .online-btn, .send-btn {
    width: 100%;
    margin-bottom: 8px;
  }
}
</style>
