<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- CSS -->
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

    <main class="news sarabun-regular mt-5">
        <div class="container d-flex justify-content-start align-items-start gap-4 mb-4">
            <a class="btn-back btn btn-primary d-flex align-items-center gap-2" href="news">
                <i class="fa-solid fa-arrow-left"></i>
                <span>ย้อนกลับ</span>
            </a>
            <section>
                <p class="h3 mb-3">เพิ่มข่าวสาร</p>
                <p class="text-muted">เพิ่มข่าวสารเกี่ยวกับโครงการ กิจกรรม และกิจการต่าง ๆ ของโครงการ</p>
            </section>
        </div>
        <div class="py-5">
            <div class="container">
                <form name="frmAddNews" action="add-news" class="form-news" method="POST" enctype="multipart/form-data">
                    <div class="container ">
                    	<input id="officer-id" type="hidden" name="officer-id" value="${officer.officer_id}">
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="news-title">หัวข้อ</label>
                                <input type="text" class="form-control" id="news-title" name="news-title" placeholder="" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="news-date">วันที่</label>
                                <input type="date" class="form-control" id="news-date" name="news-date" placeholder="" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="news-detail">รายละเอียด</label>
                            <textarea class="form-control" id="news-detail" name="news-desc" placeholder="" rows="7" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="imageUpload">รูปภาพ</label>
                            <input type="file" class="form-control" id="news-img" name="imageUpload" accept=".png, .jpg, .jpeg*" multiple>
                        </div>
                        <div class="d-flex justify-content-end mb-4 mt-5">
                            <button class="btn btn-primary btn-block" type="submit">เพิ่มข่าว</button>
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
	        // กำหนดให้ news-date เป็นวันที่ปัจจุบัน
	        const newsDateInput = document.getElementById("news-date");
	        
	        const today = new Date();
	        const yyyy = today.getFullYear();
	        let mm = today.getMonth() + 1; // เดือนเริ่มต้นที่ 0
	        let dd = today.getDate();
	
	        if (mm < 10) mm = '0' + mm; 
	        if (dd < 10) dd = '0' + dd; 
	
	        const formattedDate = yyyy + '-' + mm + '-' + dd;
	        
	        newsDateInput.value = formattedDate;
	    });
	</script>
	<script>
	    document.addEventListener("DOMContentLoaded", function () {
	        const form = document.forms["frmAddNews"];
	        const newsTitle = document.getElementById("news-title");
	       // const newsDate = document.getElementById("news-date"); 
	        const newsDetail = document.getElementById("news-detail");
	        const newsImg = document.getElementById("news-img");
	
	        form.addEventListener("submit", function (e) {
	            let errors = []; // สะสมข้อความผิดพลาด
	
	            // ตรวจสอบความยาวของหัวข้อ
	            if (newsTitle.value.trim().length === 0) {
	                errors.push("กรุณากรอกหัวข้อข่าว!");
	            } else if (newsTitle.value.length > 100) {
	                errors.push("หัวข้อข่าวต้องไม่เกิน 100 ตัวอักษร!");
	            }
	
	            // ตรวจสอบวันที่
	            //if (newsDate.value.trim().length === 0) {
	            //    errors.push("กรุณาเลือกวันที่!");
	            //}
	
	            // ตรวจสอบรายละเอียด
	            if (newsDetail.value.trim().length === 0) {
	                errors.push("กรุณากรอกรายละเอียดข่าว!");
	            }
	
	            // ตรวจสอบไฟล์รูปภาพ
	            if (newsImg.files.length === 0) {
	                errors.push("กรุณาอัปโหลดรูปภาพ!");
	            }
	
	            // หากมีข้อผิดพลาด
	            if (errors.length > 0) {
	                e.preventDefault(); // ป้องกันการส่งฟอร์ม
	                Swal.fire({
	                    icon: 'error',
	                    title: 'ข้อมูลไม่ถูกต้อง',
	                    html: errors.join('<br>'), // แสดงข้อความข้อผิดพลาดทั้งหมด
	                });
	            }
	        });
	    });
	</script>

    
	
</body>
</html>