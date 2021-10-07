<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/writeboard.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=vjjh2gafg5"></script>
	<style>
li input{
	border:none;
	outline: none;
}
#deal_price{
	border-bottom: 1px solid silver;
}
hr{
	border: 1px solid green;
}
#replyarea input{
	border-bottom: 1px solid silver;
}
</style>
<script>
//경매 시간
function remaindTime() {
    var date = '${list.writedate}';
    var day=date.substr(0,10);
    var hour=date.substr(11,2);
    var min=date.substr(14,2);
    var sec=date.substr(17,2);
    var day2=new Date(day);
    var now=new Date();
    var start = new Date(day2.getFullYear(),day2.getMonth(),day2.getDate(),hour,min,sec);
    var end = new Date(day2.getFullYear(),day2.getMonth(),day2.getDate()+2,hour,min,sec);
    
    var nt = now.getTime();
    var st = start.getTime(); 
    var et = end.getTime(); 

   if(nt>et){ 
    $(".lefttime").text("금일 마감");
    $(".time").fadeOut();
   }else{
     $(".time").fadeIn();
     $(".lefttime").text("입찰 마감까지");
     sec =parseInt(et - nt) / 1000;
     day  = parseInt(sec/60/60/24);
     sec = (sec - (day * 60 * 60 * 24));
     hour = parseInt(sec/60/60);
     sec = (sec - (hour*60*60));
     min = parseInt(sec/60);
     sec = parseInt(sec-(min*60));
     if(hour<10){hour="0"+hour;}
     if(min<10){min="0"+min;}
     if(sec<10){sec="0"+sec;}
     
      $(".hour").text(hour+"시간");
      $(".min").text(min+"분");
      $(".sec").text(sec+"초");
   }
 } 
 setInterval(remaindTime,1000);
//경매 기능
$(function () {
	$('#deal_btn').on('click',function(){
		var before=Number($("#ndeal_price").val());
		var after=Number($("#deal_price").val());
		   let data1={tradeno:$("#tradeno").val(),deal_price:$("#deal_price").val(),user_id:$("#user_id").val()};
		if($("#user_id").val()==null){
			alert("로그인이 필요합니다.");
		}else{
		 $.ajax({
			type:"post"
			,url:'${pageContext.request.contextPath }/deal'
		    ,dataType:"json"
			,data: JSON.stringify(data1)
			,contentType:"application/json;charset=utf-8"
			,success:function(data)
			{	
				if(after<before){
					alert("입력한 가격이 현재 입찰가 보다 낮습니다");
				}else
				alert("입찰 성공!");
				
				$('#ndeal_price').val(data);
				$('#deal_price').val(""); //초기화
			},error:function(err){
				console.log(err);
			} 
		})
		}
	})
})

</script>
<body>
<br><br><br><br>
<h3 class="lefttime" style="text-align: center;"></h3>
<div class="time" style="text-align: center;">
<span class="hour"></span>
<span class="min"></span>
<span class="sec"></span>
</div>
<br>
<ul>
	<li>
		<label>카테고리</label>
		<span>${list.category1} > </span>
		<span>${list.category2}</span>
	</li>
	<li>
		<input type="hidden" name="user_id" value="${id }">
		<input type="hidden" name="tradeno" id="tradeno" value="${list.tradeno }">
		<label>제목</label>
		<input type="text" id="title" value="${list.title }" readonly>
		<div style="float: right;">
		<label>작성자</label>
		<span> : ${list.user_id }</span>
		</div>
	</li>
	<li>
		<label>현재 입찰가격</label>
		<input type="text" id="ndeal_price" value="${price }" readonly>
		<label>입찰 희망가격</label>
		<input type="text" id="deal_price" name="deal_price" >
		<button id="deal_btn" >입찰하기</button>
		<div style="float: right;">
		<c:if test="${result ne null }">
		<img class="like_btn" alt="좋아요" src="${pageContext.request.contextPath }/resources/img/하트.png" width="30px" height="30px">
		</c:if>
		<c:if test="${result eq null }">
		<img class="like_btn" alt="좋아요" src="${pageContext.request.contextPath }/resources/img/빈하트.png" width="30px" height="30px">
		</c:if>
		</div>
	</li>
	<li>
		<label>첨부 사진</label>
		<c:if test="${list2!=null }">
		<div class="preview">
			<c:forEach var="item" items="${list2 }">
				<div class="preview-box">
					<img src="${pageContext.request.contextPath }/resources/img/${item.real_name}" width="100px" height="100px">
				</div>
			</c:forEach>
		</div>
		</c:if>
	<div class="clear"></div>
	</li>
	<li>
		<textarea rows="14" cols="68" class="left" readonly>${list.content }</textarea>
		<div class="right">
		<label>장소 설정</label>
		<p id="map" style="width: 500px; height: 400px;"></p>
		</div>
	</li>
	<li>
	<div class="clear"></div>
		<c:if test="${id == list.user_id }">
		<input type="button" id="modibtn" value="수정" onclick="location.href='${pageContext.request.contextPath }/twritemodify/${list.tradeno}'">
		<input type="button" id="delbtn" value="삭제" onclick="location.href='${pageContext.request.contextPath }/twritedelete/${list.tradeno}'">
		</c:if>
		<Br><br>
	</li>
	<c:if test="${not empty list3}">
	<li>
		<label>댓글</label>
		<hr>
		<div id="replyarea">
		<c:forEach var="item" items="${list3 }">
			<li value="${item.replyno }">
				<c:if test="${item.dept==1 }">
					<img  src="${pageContext.request.contextPath }/resources/img/화살표.jfif" width="40px" height="25px" style="margin-left:${20*item.dept}px;"> 
				</c:if>
				<input type="text" name="user_id" value="${item.user_id }" readonly>
				<input type="text" name="reply_writedate" value="${item.reply_writedate }" readonly>
				<div class="replychild_btn" style="margin-left:${60*item.dept}px;">
						${item.reply_content }
					<c:if test="${id eq item.user_id && item.dept==0}">
						<a href="${pageContext.request.contextPath }/treplydelete/${item.replyno}/${list.tradeno}" style="color: red; font-size: 13px;">삭제</a>
					</c:if>
					<c:if test="${id eq item.user_id && item.dept==1}">
						<a href="${pageContext.request.contextPath }/treplydelete2/${item.replyno}/${list.tradeno}" style="color: red; font-size: 13px;">삭제</a>
					</c:if>
				</div>
				<input type="hidden" value="${item.replyno }" name="replyno" class="replyno">
				<input type="hidden" value="${item.dept }" name="dept" class="dept">
				<input type="hidden" value="${item.reorder }" name="reorder" class="reorder">
				<input type="hidden" value="${item.reparent }" name="reparent" class="reparent">
			</li>
		</c:forEach>
		</div>
	</li>
	<hr>
	</c:if>
	<li>
	<c:if test="${id ne null}">
		<div><br>	
			<div id="replydiv">
				<form action="${pageContext.request.contextPath }/tdreplyresult" method="post">
				<input type="hidden" id="tradeno" name="tradeno" value="${list.tradeno }">
				<input type="text" id="user_id" name="user_id" value="${id }" readonly><br> 
				<textarea rows="4" cols="90" id="reply_content" name="reply_content" placeholder="댓글을 입력하세요." required></textarea>
				<input type="submit" value="등록">
				</form>
			</div>
		</div>
	</c:if>
	</li>
</ul>	
<script src="${pageContext.request.contextPath}/resources/js/writeboard.js"></script>
<script>
//좋아요
$(function () {
	$(".like_btn").on("click",function(){
		let id=$("#user_id").val();
		let tradeno=${list.tradeno}
		let data1={user_id:id,tradeno:tradeno};
		if(id == null){
			alert("로그인이 필요합니다.");
		}else{
			$.ajax({
				type:"post"
				,url:"${pageContext.request.contextPath}/tlike"
				,dataType:'json'
				,data: JSON.stringify(data1)
				,contentType:"application/json;charset=utf-8"
				,success:function(data){
					if(data!=1){
						alert("이 글을 좋아요 하였습니다.");
						$(".like_btn").attr("src","${pageContext.request.contextPath}/resources/img/하트.png");
					}else{
						alert("좋아요를 취소하였습니다.");	
						$(".like_btn").attr("src","${pageContext.request.contextPath}/resources/img/빈하트.png");
					}
				},error:function(err){
					console.log("에러");
				}
			}) 
		}
	})
})
//대댓글
$(function () {
	$(".replychild_btn").on("click",function(){
		
		let $this=$(this);
		let no=$this.parent().val();
		let data1={tradeno:$("#tradeno").val()
					,replyno:no
					};
		let id="${id}";
		console.log(no);
 	$.ajax({
			type:'post'
			,url:"${pageContext.request.contextPath }/treplychild"
			,dataType:'json'
			,data: JSON.stringify(data1)
			,contentType:"application/json;charset=utf-8"
			,success:function(data)
			{
				console.log("성공");
				let p="";
				p+="<form method='post' class='replyform' action='${pageContext.request.contextPath }/treplychildinsert'>";
	 			p+="<input type='hidden' name='user_id' value='"+id+"'>";
				p+="<input type='hidden' name='tradeno' value='"+${list.tradeno }+"'>";
				p+="<textarea rows='4' cols='90' name='reply_content' placeholder='댓글을 입력하세요.' style='margin-left:25px;'></textarea>";
				p+="<input type='hidden' name='reorder' value='"+data.reorder+"'>";
				p+="<input type='hidden' name='reparent' value='"+no+"'>";
				p+="<input type='submit' value='댓글달기'>";
				p+="</form>";
				
				$('.replyform').remove();
				$this.parent().append(p);
			},error:function(err){
				console.log("에러");
			}
		})  
	})
})

</script>
<script>

var mapOptions = {
		center : new naver.maps.LatLng(${list.map_x},${list.map_y}),
		zoom : 18
	};
var map = new naver.maps.Map('map', mapOptions);

var markerList = [];
var marker = new naver.maps.Marker({
    position: new naver.maps.LatLng(${list.map_x}, ${list.map_y}),
    map: map
});

</script>
</body>
</html>