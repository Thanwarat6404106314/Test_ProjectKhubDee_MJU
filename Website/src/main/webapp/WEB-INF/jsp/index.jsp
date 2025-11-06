<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/indentity/index.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/components/fonts.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/utils.css?v=<%= System.currentTimeMillis() %>">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- jQuery and Bootstrap JS -->
    <!-- Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800&display=swap" rel="stylesheet">
    <link href="https://kit-pro.fontawesome.com/releases/v6.2.0/css/pro.min.css" rel="stylesheet">
    
    <!-- Jquery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    
    <link rel="icon" href="assets/images/favicon/icon.png" type="image/png">
    <link rel="shortcut icon" href="assets/images/favicon/icon.png" type="image/png">
    <title>KHUBDEE MJU</title>
</head>

<style>
    .carousel-item img {
        margin: 0;
        padding: 0;
        width: 100%;
        height: auto;
    }
    .carousel-fade .carousel-item {
        opacity: 0;
        transition: opacity 0.5s ease-in-out;
    }
    .carousel-fade .carousel-item.active {
        opacity: 1;
    }
</style>

<body>
    <div class="container">
    	<header class="blog-header">
        	<a class="blog-header-logo" href="index">
            	<img class="img-fluid" src="assets/images/logo/logo_dark.png" alt="LOGO">
			</a>
    	</header>
    </div>
    
    <jsp:include page="navbar/navbar1.jsp" />
 
    <main class="sarabun-regular mt-2">
   		<!-- Carousel Slide-->
   		<div id="carouselExample" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="4000">
		    <div class="carousel-inner">
		        <div class="carousel-item active">
		            <img src="assets/images/banner/banner_01.png" class="d-block w-100" alt="BANNER1">
		        </div>
		        <div class="carousel-item">
		            <img src="assets/images/banner/banner_02.png" class="d-block w-100" alt="BANNER2">
		        </div>
		    </div>
		    
		    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
		        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		        <span class="visually-hidden">Previous</span>
		    </button>
		    <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
		        <span class="carousel-control-next-icon" aria-hidden="true"></span>
		        <span class="visually-hidden">Next</span>
		    </button>
		</div>
	    
	    <!-- List Topic -->
        <section id="list-topics" class="list-topics">
		    <div class="container">
		        <div class="list-topics-content">
		            <ul>
		                <li>
		                    <a href="index" class="p-3 single-list-topics-content">จัดการข่าวสาร</a>
		                </li>
		                <li>
		                    <a href="index" class="p-3 single-list-topics-content">จัดการนักศึกษาที่ละเมิดกฎจราจร</a>
		                </li>
		                <li>
		                    <a href="index" class="p-3 single-list-topics-content">ตรวจสอบสถิติการละเมิดกฎจราจร</a>
		                </li>
		            </ul>
		        </div>
		    </div>
		</section>
        
        <!-- Next -->
	    
	    
    </main>
    
    <footer class="blog-footer sarabun-regular">
		<div class="ft-container">
			<div class="ft-copyright">
				<p>Copyright ©&nbsp; 2025 | ขับดี | กองพัฒนานักศึกษา มหาวิทยาลัยแม่โจ้  </p>
			</div>
		</div>
	</footer>
    
    <!-- JS -->
    
    <script src="assets/js/utils.js?v=<%= System.currentTimeMillis() %>"></script>
    <script>
	    var sucMsg = "${success}";
	    if (sucMsg) {
	        Swal.fire({
	            icon: 'success',
	            title: 'ยินดีต้อนรับ!',
	            text: sucMsg
	        }).then(() => {
	            var userData = {
                    isLoggedIn: true,
                    officer_id: '${dataAdmin.officer_id}'
                };
	        	localStorage.setItem('userStorage', JSON.stringify(userData));
	        	
	            const navbar = document.querySelector('navbar-component');
	            if (navbar) {
	                navbar.render(userData.isLoggedIn);
	            }
	        });
	    }
	</script>
</body>
</html>