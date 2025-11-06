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
    <link rel="stylesheet" href="assets/css/components/fonts.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/utils.css?v=<%= System.currentTimeMillis() %>">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- JS -->
    <script src="assets/js/utils.js?v=<%= System.currentTimeMillis() %>"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
    
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
	            <p class="h3 mb-3">สถิติการละเมิดกฎจราจร</p>
	            <p class="text-muted">สถิติการละเมิดกฎจราจรของนักศึกษา ภายในมหาวิทยาลัยแม่โจ้</p>
	        </section>
	    </div>
	    
	    
	    <div class="container d-flex justify-content-center align-items-center">
			<h4 class="">กราฟแสดงสถิติการละเมิดกฎจราจรแยกตามประเภทและคิดเป็นร้อยละ</h4>
		</div>
		
		<div class="container d-flex justify-content-center align-items-center mt-3">
			<input id="showYearly" type="hidden">
            <form id="dateFilterForm" class="form-inline" method="GET" action="statistics-violation">
                <div class="form-group mb-2">
                    <label for="startDate" class="mr-2">วันที่เริ่มต้น:</label>
                    <input type="date" id="startDate" class="form-control" name="startDate" value="${startDate}" required value="${startQuery}">
                </div>
                <div class="form-group mx-sm-3 mb-2">
                    <label for="endDate" class="mr-2">วันที่สิ้นสุด:</label>
                    <input type="date" id="endDate" class="form-control" name="endDate" value="${endDate}" required>
                </div>
                <button type="submit" class="btn btn-primary mb-2">ค้นหาสถิติ</button>
            </form>
        </div>
	    
	    <div class="album py-1">
	        <div class="container">
	            <div class="chart">
	                <canvas id="violationChart" class="mt-1" width="150" height="50"></canvas>
	            </div>
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
     
    <!-- Statistic Chart -->
	<script>
	    const countsViolation = {
	        "ขับขี่ไม่สวมหมวกกันน็อค": ${countViolation['ขับขี่ไม่สวมหมวกกันน็อค'] != null ? countViolation['ขับขี่ไม่สวมหมวกกันน็อค'] : 0},
	        "ขับขี่ด้วยความเร็วเกินกำหนด": ${countViolation['ขับขี่ด้วยความเร็วเกินกำหนด'] != null ? countViolation['ขับขี่ด้วยความเร็วเกินกำหนด'] : 0},
	        "ขับขี่ย้อนศร": ${countViolation['ขับขี่ย้อนศร'] != null ? countViolation['ขับขี่ย้อนศร'] : 0},
	        "ขับขี่โดยประมาท": ${countViolation['ขับขี่โดยประมาท'] != null ? countViolation['ขับขี่โดยประมาท'] : 0}
	    };
	
	    const totalsViolation = ${totalViolation};
	
	    const ctx = document.getElementById('violationChart').getContext('2d');
	    let violationChart;
	
	    function createChart(data, labels, title, originalData) {
	        if (violationChart) {
	            violationChart.destroy(); 
	        }
	
	        violationChart = new Chart(ctx, {
	            type: 'bar',
	            data: {
	                labels: labels,
	                datasets: [{
	                    label: title,
	                    data: data, 
	                    backgroundColor: ['#fe0402', '#01b7f8', '#fed40a', '#01e900'],
	                    borderColor: ['#fe0402', '#01b7f8', '#fed40a', '#01e900'],
	                    borderWidth: 1
	                }]
	            },
	            options: {
	                plugins: {
	                    legend: {
	                        display: true,
	                        labels: {
	                            font: {
	                                size: 16,
	                                family: 'Sarabun',
	                            },
	                            generateLabels: function(chart) {
	                                return [{
	                                    text: chart.data.datasets[0].label,
	                                    fillStyle: 'transparent',
	                                    strokeStyle: 'transparent',
	                                    hidden: false,
	                                    lineWidth: 0
	                                }];
	                            }
	                        }
	                    },
	                    tooltip: {
	                        callbacks: {
	                            label: function(context) {
	                                const index = context.dataIndex;
	                                const originalValue = originalData[index];
	                                return "จำนวน: "+ originalValue + " ครั้ง"; 
	                            }
	                        }
	                    },
	                    datalabels: {
	                        color: '#000',
	                        anchor: 'end',
	                        align: 'top',
	                        formatter: function(value) {
	                            return value.toFixed(2) + " %";
	                        }
	                    }
	                },
	                scales: {
	                    x: {
	                        title: {
	                            display: true,
	                            text: 'ประเภทการละเมิดกฎจราจร',
	                            font: {
	                                size: 16,
	                                family: 'Sarabun',
	                                weight: 'bold'
	                            }
	                        }
	                    },
	                    y: {
	                        title: {
	                            display: true,
	                            text: 'ร้อยละ',
	                            font: {
	                                size: 16,
	                                family: 'Sarabun',
	                                weight: 'bold'
	                            }
	                        },
	                        min: 0,
	                        max: 100,
	                        ticks: {
	                            callback: function(value) {
	                                return value + '%';
	                            }
	                        }
	                    }
	                }
	            },
	            plugins: [ChartDataLabels]
	        });
	    }

	    function calculatePercentages(data, total) {
	        return Object.values(data).map(value => total > 0 ? (value / total) * 100 : 0);
	    }
	
	    document.getElementById('showYearly').addEventListener('click', function() {
	        const labels = Object.keys(countsViolation);
	        const percentages = calculatePercentages(countsViolation, totalsViolation);
	        const originalData = Object.values(countsViolation);
	        const title = "ข้อมูลการละเมิดกฎจราจร รวมทั้งสิ้น: " + totalsViolation;
	        createChart(percentages, labels, title, originalData);
	    });
	
	    document.getElementById('showYearly').click();
	</script>


	
    
	
	
</body>
</html>