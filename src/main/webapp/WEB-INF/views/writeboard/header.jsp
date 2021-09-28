<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="../include/menu.jsp" %>
<c:if test="${msg =='success' }">
<h2>${sessionScope.nick_name }(${sessionScope.user_id })님 환영합니다</h2>
</c:if>

    <div class="main">
		<header>
			<div class="page-header">
				<h1><a href="mainpage">오이마켓</a></h1>
				<h4>오늘도 이웃과 거래하는 오이마켓</h4>
			</div>
		</header>
    </div>

		<nav class="menu">
		<ul>
			<li><a href="mainpage">전체</a>
			<a href="">판매</a>
			<a href="">동네 커뮤니티</a>
			<a href="qnalist">Q&A</a></li>
		</ul>
		</nav>

</body>
</html>