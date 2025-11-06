<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/components/fonts.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/utils.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/indentity/news.css?v=<%= System.currentTimeMillis() %>">

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

<body>

    <div class="container sarabun-regular">
	    <header class="blog-header d-flex justify-content-between align-items-center">
	        <!-- โลโก้ชิดซ้าย -->
	        <a class="blog-header-logo" href="home">
	            <img class="img-fluid" src="assets/images/logo/logo_dark.png" alt="LOGO">
	        </a>
	        
	        <div class="officer-info ms-3 text-start d-flex flex-column align-items-start">
			    <div class="mb-2">
			        <i class="fas fa-user me-2 text-success"></i>
			        <span class="text-success">คุณ, ${officer.firstname} ${officer.lastname}</span>
			    </div>
			    <div>
			        <i class="fas fa-briefcase me-2 text-success"></i>
			        <span class="text-success">${officer.position}</span>
			    </div>
			</div>
	    </header>
	</div>
    
    <jsp:include page="navbar/navbar2.jsp" />

    <main class="news news-edit sarabun-regular mt-5">
        <div class="container d-flex justify-content-start align-items-start gap-4 mb-4">
            <a class="btn-back btn btn-primary d-flex align-items-center gap-2" href="news">
                <i class="fa-solid fa-arrow-left"></i>
                <span>ย้อนกลับ</span>
            </a>
            <section>
                <p class="h3 mb-3">แก้ไขข่าวสาร</p>
                <p class="text-muted">แก้ไขข่าวสาร และกดปุ่ม "บันทึก" เพื่อบันทึกข้อมูล</p>
            </section>
        </div>
        <div class="py-2 ">
            <div class="container">
                <form name="frmEditNews" action="edit-news" class="form-news" method="POST" enctype="multipart/form-data">
                    <div class="container d-flex flex-column align-item-start">
                    	<input id="officer-id" type="hidden" name="officer-id" value="${officer.officer_id}">
                    	<input id="news-id" type="hidden" name="news_id" value="${news.news_id}">
                        <!--  
						<div class="img-container">
						    <div class="row">
						        <c:forEach items="${fn:split(news.image, ',')}" var="image">
						            <div class="col-md-3 col-sm-6 col-12 mb-3">
						                <img src="img_news/${image}" alt="${news.news_id}" class="img-thumbnail img-size">
						            </div>
						        </c:forEach>
						    </div>
						</div>
						-->
                        <div class="mb-3">
                            <label for="news-title">หัวข้อ</label>
                            <textarea class="form-control" id="news-title" name="news-title" placeholder="" rows="1" required>${news.title}</textarea>
                        </div>
                        <div class="mb-3">
                            <label for="news-detail">รายละเอียด</label>
                            <textarea class="form-control" id="news-desc" name="news-desc" placeholder="" rows="10" required>${news.description}</textarea>
                        </div>
                        <div class="mb-3">
                            <label for="news-date">วันที่โพส</label>
                            <input type="date" class="form-control" id="news-date" name="news-date" value="${postDateTH}">
                        </div>
                        <div class="mb-3">
                            <label for="news-img">รูปภาพ</label>
                            <input type="file" class="form-control" id="news-img" name="imageUpload" multiple>
						    <small class="form-text text-muted">
						           ไฟล์ปัจจุบัน: ${news.image != null ? news.image : "ไม่มีไฟล์ที่อัปโหลด"}
						    </small>
                        </div>
                        <div class="d-flex justify-content-end mb-4 mt-2">
                            <button class="btn btn-primary btn-block" type="submit">ยืนยัน</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
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
	    document.addEventListener("DOMContentLoaded", function () {
	        const form = document.forms["frmEditNews"];
	        const newsTitle = document.getElementById("news-title");
	
	        form.addEventListener("submit", function (e) {
	            if (newsTitle.value.trim().length > 100) {
	                e.preventDefault(); // ป้องกันการส่งฟอร์ม
	                Swal.fire({
	                    icon: 'error',
	                    title: 'ข้อมูลไม่ถูกต้อง',
	                    text: 'หัวข้อข่าวต้องไม่เกิน 100 ตัวอักษร!',
	                });
	            }
	        });
	    });
	</script>
    
</body>
</html>