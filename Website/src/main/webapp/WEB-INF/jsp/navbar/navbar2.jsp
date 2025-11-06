<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% 
    Officer officer = (Officer) session.getAttribute("officer");
%>
<nav class="nav-scroller mb-2">
    <div class="container">
        <ul class="nav sarabun-regular">
            <li><a class="p-3" href="home">หน้าหลัก</a></li>
            <li><a class="p-3" href="news">ข่าวสาร</a></li>
            <li><a class="p-3" href="location">สถานที่</a></li>
            <li class="nav-item dropdown">
                <a class="p-3 dropdown-toggle" href="" id="recDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    รายชื่อนักศึกษาที่ละเมิดกฎจราจร  <i class="fa-solid fa-chevron-down"></i>
                </a>
                <ul class="dropdown-menu" aria-labelledby="recDropdown">
                	<li><a class="dropdown-item" href="list-violation">สถานะกำลังพิจารณา</a></li>
                    <li><a class="dropdown-item" href="list-violation-approved">สถานะอนุมัติหักคะแนนพฤติกรรม</a></li>
                    <li><a class="dropdown-item" href="list-violation-rejected">สถานะไม่อนุมัติหักคะแนนพฤติกรรม</a></li>
                </ul>
            </li>
            <li><a class="p-3" href="statistics-violation">สถิติการละเมิดกฎจราจร</a></li>
            <li><a id="signout" class="p-3" href="logout">ออกจากระบบ</a></li>
        </ul>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const signOutButton = document.querySelector('#signout');
        if (signOutButton) {
            signOutButton.addEventListener('click', (e) => {
                e.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'คุณต้องการออกจากระบบ?',
                    text: 'กดยืนยันเพื่อออกจากระบบ',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'ยืนยัน',
                    cancelButtonText: 'ยกเลิก'
                }).then((result) => {
                    if (result.isConfirmed) {
                        Swal.fire({
                            title: 'สำเร็จ!',
                            text: 'คุณได้ออกจากระบบแล้ว.',
                            icon: 'success'
                        }).then(() => {
                            window.location.href = 'logout';
                        });
                    }
                });
            });
        }
    });
</script>
