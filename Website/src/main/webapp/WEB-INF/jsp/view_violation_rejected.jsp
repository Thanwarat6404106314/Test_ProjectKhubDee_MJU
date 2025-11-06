<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/components/fonts.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/utils.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/indentity/violation.css?v=<%= System.currentTimeMillis() %>">

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
    
    <main class="news news-view sarabun-regular mt-5">
        <div class="container d-flex justify-content-start align-items-start gap-4 mb-4">
            <a class="btn-back btn btn-primary d-flex align-items-center gap-2" href="list-violation-rejected">
                <i class="fa-solid fa-arrow-left"></i>
                <span>ย้อนกลับ</span>
            </a>
            <section>
                <p class="h3 mb-3">ข้อมูลการกระทำผิดกฎจราจรของนักศึกษา</p>
            </section>
        </div>
        
        <div class="album py-2 mt-2">
		    <div class="container">
		        
		       	<form action="#" class="form-viewviolation">
                    <div class="container d-flex flex-column align-item-start">
                    
                        <h4 class="mt-2">ข้อมูลนักศึกษา</h4>
		        		<br>
                        <div class="row mb-3 ">
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="major" class="me-3 mb-0 text-nowrap">รหัสนักศึกษา :</label>
						        <input type="text" class="form-control" id="student_id" placeholder="${RVR.student.student_id}" readonly disabled>
						    </div>
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="news-title" class="me-3 mb-0 text-nowrap">ชื่อ-นามสกุล :</label>
	                            <input type="text" class="form-control" id="name" placeholder="${RVR.student.firstname} ${RVR.student.lastname}" readonly disabled>
	                        </div>
						</div>
                        
                        <div class="row mb-3">
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="major" class="me-3 mb-0 text-nowrap">คณะ :</label>
						        <input type="text" class="form-control" id="major" placeholder="${RVR.student.major}" readonly disabled>
						    </div>
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="faculty" class="me-3 mb-0 text-nowrap">สาขา :</label>
						        <input type="text" class="form-control" id="faculty" placeholder="${RVR.student.faculty}" readonly disabled>
						    </div>
						</div>
						<div class="row mb-3">
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="major" class="me-3 mb-0 text-nowrap">คะแนนพฤติกรรม คงเหลือ :</label>
						        <input type="text" class="form-control" id="student_score" placeholder="${RVR.student.student_score} คะแนน" readonly disabled>
						    </div>
						</div>
						
						<h4 class="mt-3">ข้อมูลการละเมิดกฎจราจร</h4>
		        		<br>
		        		<div class="row mb-3">
			        		<div class="col-md-6 d-flex align-items-center" >
								<label for="officer_id" class="me-3 mb-0 text-nowrap">เจ้าหน้าที่ที่บันทึก :</label>
							    <input type="text" class="form-control" id="officer_id" placeholder="${RVR.officer.firstname} ${RVR.officer.lastname}" readonly disabled>
							</div>
						</div>
		        		<div class="row mb-3">
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="record_date" class="me-3 mb-0 text-nowrap">วันที่ละเมิดกฎจราจร :</label>
						    	<input type="text" class="form-control" placeholder="<fmt:formatDate value='${RVR.record_date}' pattern='dd/MM/yyyy' />" readonly disabled>
						    </div>
						    <div class="col-md-6 d-flex align-items-center">
						        <label for="record_date" class="me-3 mb-0 text-nowrap">เวลา :</label>
						    	<input type="text" class="form-control" placeholder="<fmt:formatDate value='${RVR.record_date}' pattern='HH:mm น.' />" readonly disabled>
	                        </div>
						</div>
						<div class="row mb-3">
							<div class="col-md-6 d-flex align-items-center">
								<label for="location" class="me-3 mb-0 text-nowrap">สถานที่ :</label>
							    <input type="text" class="form-control" id="location" placeholder="${RVR.location.location_name}" readonly disabled>
							</div>
							<div class="col-md-6 d-flex align-items-center">
								<label for="status_type" class="me-3 mb-0 text-nowrap">ประเภทความผิด :</label>
								<input type="text" class="form-control" id="violation_type" placeholder="${RVR.violationType.violation_name}" readonly disabled>
							</div>
						</div>	
						<div class="row mb-3">
							<div class="col-md-6 d-flex align-items-center">
								<label for="status_type" class="me-3 mb-0 text-nowrap">สถานะ :</label>
								<input type="text" class="form-control" id="status_type" placeholder="${RVR.status_type}" readonly disabled>
							</div>
						</div>
						<div class="mb-3">
							<label for="status_type">รูปภาพการกะทำผิดกฎจราจร :</label>
							<div class="img-container mt-3">
                            	<img id="violation-image" src="picture_evidence/${RVR.picture_evidence}" alt="${RVR.record_id}">
                        	</div>
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
    
</body>
</html>