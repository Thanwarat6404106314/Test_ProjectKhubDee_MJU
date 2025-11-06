<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <link rel="stylesheet" href="assets/css/indentity/list_news.css?v=<%= System.currentTimeMillis() %>">

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

    <main class="news sarabun-regular mt-5" >
        <div class="container d-flex justify-content-between align-items-end mb-4">
            <section>
                <p class="h3 mb-3">สถานที่</p>
                <p class="text-muted">สถานที่ที่เกี่ยวข้องกับจุดบริการต่าง ๆ สำหรับเจ้าหน้าที่</p>
            </section>
        </div>     
        
        <!--  
        <div class="container d-flex justify-content-center align-items-center">
	    	<form class="d-flex" action="searchNews" method="POST">
	        	<input type="text" name="searchtext" class="form-control " placeholder="ค้นหาข่าว" style="min-width: 400px;">
	        	<input type="submit" class="btn btn-secondary ms-3" style="min-width: 103px;" value="ค้นหา">
	        </form>    
	    </div>
	    -->
	    
        <div class="album py-2">
	        <div class="container d-flex justify-content-end align-items-center">
				<a class="btn btn-primary" href="viewAddLocation">
		        	<i class="fa-solid fa-plus me-2"></i>
		        	<span>เพิ่มสถานที่</span>
		        </a>
			</div>
        	
            <div class="container mt-3">
                <table class="table table-striped" id="myTable">
		            <thead class="thead">
		                <tr>
		                    <th scope="col">รหัสสถานที่</th>
		                    <th scope="col">ชื่อสถานที่</th>
		                    <th scope="col" colspan="2"></th>
		                </tr>
		            </thead>
		            <tbody>
					    <c:forEach items="${ListLocation}" var="location">
					        <tr>
								<td>${location.location_id}</td>
					            <td>${location.location_name}</td>
					            <td>
					            	<a class="btn btn-sm btn-primary me-3" href="viewEditLocation?location_id=${location.location_id}">
					                	<i class="fa-light fa-edit"></i>
					                </a>
					                <button class="btn btn-sm btn-primary me-3" onclick="deleteLocation('${location.location_id}')">
										<i class="fa-light fa-trash"></i>
									</button>
					            </td>
					        </tr>
					    </c:forEach>
					</tbody>
		        </table>
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
		function deleteLocation(location_id) {
		    Swal.fire({
		        icon: 'warning',
		        title: 'คุณต้องการลบข้อมูลนี้?',
		        text: 'กดยืนยันเพื่อลบออกจากระบบ',
		        showCancelButton: true,
		        confirmButtonColor: '#3085d6',
		        cancelButtonColor: '#d33',
		        confirmButtonText: 'ยืนยัน',
		        cancelButtonText: 'ยกเลิก'
		    }).then((result) => {
		        if (result.isConfirmed) {
		            $.ajax({
		                url: 'delete-location',
		                type: 'POST',
		                data: { location_id: location_id},
		                success: function(response) {
		                    Swal.fire({
		                        icon: 'success',
		                        title: 'สำเร็จ!',
		                        text: 'ลบสถานที่สำเร็จ'
		                    }).then(() => {
		                        location.reload(); // reload หน้าเพื่อให้ข้อมูลล่าสุด
		                    });
		                },
		                error: function(xhr) {
		                    Swal.fire({
		                        icon: 'error',
		                        title: 'แจ้งเตือน!',
		                        text: 'ไม่สามารถลบสถานที่ได้ เนื่องจากยังมีการใช้งานสถานที่นี้อยู่' 
		                    });
		                }
		            });
		        }
		    });
		}
	</script>
</body>
</html>
