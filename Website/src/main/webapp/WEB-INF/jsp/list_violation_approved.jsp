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
    <link rel="stylesheet" href="assets/css/indentity/list_violation.css?v=<%= System.currentTimeMillis() %>">
    
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
    
    <main class="listviolation sarabun-regular mt-5">
        <div class="container d-flex justify-content-between align-items-end mb-4">
            <section>
                <p class="h3 mb-3">รายชื่อนักศึกษาที่ละเมิดกฎจราจร</p>
                <p class="h5 text-muted">สถานะ: อนุมัติหักคะแนนพฤติกรรม</p>
            </section>
        </div>
        
        <div class="container d-flex justify-content-center align-items-center">
		   	<form class="d-flex" action="search-approved" method="GET">
			    <input type="text" name="searchText" class="form-control me-1" placeholder="ค้นหารหัสนักศึกษาหรือข้อมูลของนักศึกษา" style="min-width: 400px;" value="${searchQuery}">
			    <span class="mx-2 align-self-center">หรือ</span>
			    <input type="date" name="startDate" class="form-control ms-1" placeholder="วันที่เริ่มต้น" value="${startQuery}">
			    <input type="submit" class="btn btn-secondary ms-2" style="min-width: 103px;" value="ค้นหา">
			</form>
		   	
	    </div>
        
        <div class="album py-2 mt-3 ">
			
		    <div class="container mt-3">
		        <table class="table table-striped" id="myTable">
		            <thead class="thead">
		                <tr>
		                    <th scope="col">ลำดับ</th>
		                    <th scope="col">รหัสนักศึกษา</th>
		                    <th scope="col">ชื่อ-นามสกุล</th>
		                    <th scope="col">วันที่ละเมิด</th>
		                    <th scope="col">คะแนนคงเหลือ</th>
		                    <th scope="col">คะแนนที่ถูกหัก</th>
		                    <th scope="col" colspan="2">สถานะ</th>
		                    <th scope="col"></th>
		                </tr>
		            </thead>
		            <tbody>
					    <c:forEach items="${ListRVApproved}" var="RV" varStatus="NO">
					        <tr>
					            <form action="update-statustype" method="POST" onsubmit="return confirmChangeStatus(this)">
					                <input type="hidden" name="record-id" value="${RV.record_id}">
					                <input type="hidden" name="page" value="${currentPage}">
    								<input type="hidden" name="size" value="${pageSize}">
    								<input type="hidden" name="current-status" value="${RV.status_type}">
    								
					                <td>${(currentPage - 1) * pageSize + NO.index + 1}</td>
					                <td>${RV.student.student_id}</td>
					                <td>${RV.student.firstname} ${RV.student.lastname}</td>
					                <td>
					                    <fmt:formatDate value="${RV.record_date}" pattern="dd/MM/yyyy" />
					                </td>
					                <td>${RV.remaining_score}</td>
					                <td>${RV.violationType.deduct_score}</td>
					                <td>
					                    <c:choose>
					                        <c:when test="${officer.position == 'หัวหน้าฝ่ายระเบียบวินัย'}">
					                            <select name="status-type" class="form-control data" disabled>
					                                <option value="กำลังพิจารณา" ${RV.status_type == 'กำลังพิจารณา' ? 'selected' : ''}> กำลังพิจารณา</option>
					                                <option value="อนุมัติหักคะแนนพฤติกรรม" ${RV.status_type == 'อนุมัติหักคะแนนพฤติกรรม' ? 'selected' : ''}>อนุมัติหักคะแนนพฤติกรรม</option>
					                                <option value="ไม่อนุมัติหักคะแนนพฤติกรรม" ${RV.status_type == 'ไม่อนุมัติหักคะแนนพฤติกรรม' ? 'selected' : ''}> ไม่อนุมัติหักคะแนนพฤติกรรม</option>
					                            </select>
					                        </c:when>
					                        <c:when test="${officer.position == 'เจ้าหน้าที่ฝ่ายระเบียบวินัย'}">
					                            <select name="status-type" class="form-control data" disabled>
					                                <option value="กำลังพิจารณา" ${RV.status_type == 'กำลังพิจารณา' ? 'selected' : ''}>กำลังพิจารณา</option>
					                                <option value="อนุมัติหักคะแนนพฤติกรรม" ${RV.status_type == 'อนุมัติหักคะแนนพฤติกรรม' ? 'selected' : ''}>อนุมัติหักคะแนนพฤติกรรม</option>
					                                <option value="ไม่อนุมัติหักคะแนนพฤติกรรม" ${RV.status_type == 'ไม่อนุมัติหักคะแนนพฤติกรรม' ? 'selected' : ''}>ไม่อนุมัติหักคะแนนพฤติกรรม</option>
					                            </select>
					                        </c:when>
					                    </c:choose>
					                </td>
					                <td>
					                    <a class="btn btn-sm btn-primary me-2" href="view-violation-approved?record_id=${RV.record_id}">
					                        <i class="fa-light fa-eye"></i>
					                    </a>
					                    <!-- 
					                    <c:if test="${officer.position == 'หัวหน้าฝ่ายระเบียบวินัย' && RV.status_type != 'อนุมัติหักคะแนนพฤติกรรม' && RV.status_type != 'ไม่อนุมัติหักคะแนนพฤติกรรม'}">
					                        <button type="submit" class="btn btn-sm btn-primary">บันทึก</button>
					                    </c:if>
					                    -->
					                </td>
					                
					            </form>
					        </tr>
					    </c:forEach>
					</tbody>
		        </table>
		        
		        <div class="d-flex justify-content-center mt-3">
				    <c:if test="${currentPage > 1}">
				        <a class="btn btn-primary me-2" href="?page=${currentPage - 1}">
				            <i class="fa-solid fa-chevron-left"></i>
				        </a>
				    </c:if>
				    
				    <c:forEach begin="1" end="${totalPages}" var="pageNum">
					    <a class="btn btn-outline-primary me-1 ${pageNum == currentPage ? 'active' : ''}" 
					       href="?page=${pageNum}&size=${pageSize}&searchText=${searchQuery}">
					        ${pageNum}
					    </a>
					</c:forEach>
				    
				    <c:if test="${currentPage < totalPages}">
				        <a class="btn btn-primary" href="?page=${currentPage + 1}">
				            <i class="fa-solid fa-chevron-right"></i>
				        </a>
				    </c:if>
				</div>
	            
		        <c:if test="${empty ListRVApproved}">
			        <div class="alert alert-warning mt-3">
			            <strong>ไม่พบข้อมูล</strong>
			        </div>
			    </c:if>
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
    function confirmChangeStatus(form) {
    	// เข้าถึงค่า status-type
        var selectedValue = form['status-type'].value;
        console.log('Selected value:', selectedValue);
        
        var allowedStatuses = ["อนุมัติหักคะแนนพฤติกรรม", "ไม่อนุมัติหักคะแนนพฤติกรรม"];
        
        // ตรวจสอบว่าสถานะที่เลือกไม่ถูกต้อง
        if (!allowedStatuses.includes(selectedValue)) {
            Swal.fire({
                icon: 'error',
                title: 'ไม่สามารถบันทึกได้',
                text: 'กรุณาเปลี่ยนสถานะก่อนทำรายการต่อไป',
                confirmButtonText: 'ตกลง'
            });
            return false; 
        }

        // แสดงการยืนยันเมื่อสถานะถูกต้อง
        Swal.fire({
            icon: 'warning',
            title: 'ยืนยันการเปลี่ยนสถานะ?',
            text: 'คุณแน่ใจหรือไม่ว่าต้องการเปลี่ยนสถานะ',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'ยืนยัน',
            cancelButtonText: 'ยกเลิก'
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });

        return false; 
    }
	</script>
</body>
</html>
