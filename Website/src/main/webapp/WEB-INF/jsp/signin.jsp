<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/components/fonts.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/utils.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="assets/css/components/signin.css?v=<%= System.currentTimeMillis() %>">
    
    <!-- Lib -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="https://kit-pro.fontawesome.com/releases/v6.2.0/css/pro.min.css" rel="stylesheet">

    <link rel="icon" href="assets/images/favicon/icon.png" type="image/png">
    <link rel="shortcut icon" href="assets/images/favicon/icon.png" type="image/png">
    <title>KHUBDEE MJU</title>
</head>
<body>

    <form name="frmSignin" action="home" method="POST" class="form-signin d-flex flex-column align-items-center p-3">
        <div class="text-center mb-4">
            <a href="index">
                <img class="mb-4 img-fluid" src="assets/images/logo/logo_khubdee.png" alt="LOGO">
            </a>
            <p class="h3 mb-3 sarabun-regular">กรุณากรอกข้อมูลเพื่อเข้าสู่ระบบ</p>
            <p class="text-muted sarabun-regular">เพื่อให้คุณสามารถเข้าถึงฟีเจอและบริการต่าง ๆ</p>
        </div>
        <div class="form-label-group mb-4 w-100 sarabun-regular">
            <i class="fa-solid fa-envelope"></i>
            <input id="email" class="form-control" type="email" name="email" placeholder="อีเมล" required autofocus value="${email}">
        </div>
        <div id="valid-password" class="form-group mb-4 w-100 sarabun-regular">
            <div class="form-label-group">
                <i class="fa-solid fa-lock"></i>
                <input id="password" class="form-control" type="password" name="password" placeholder="รหัสผ่าน" required>
                <span id="visible-password">
                    <i class="fa-solid fa-eye-slash"></i>
                </span>
            </div>
        </div>

        <button class="btn btn-lg btn-primary btn-block w-100" type="submit">
            <i class="fas fa-sign-in-alt me-2"></i>
            <span class="sarabun-regular">เข้าสู่ระบบ</span>
        </button>
        <a href="index" class="mt-5 mb-3 text-center">
            <i class="fas fa-arrow-left me-2"></i>
            <span class="sarabun-regular">กลับหน้าหลัก</span>
        </a>
    </form>

    <!-- JS -->
    <script src="assets/js/indentity/toggle_password.js?v=<%= System.currentTimeMillis() %>"></script>
    <script src="assets/js/utils.js?v=<%= System.currentTimeMillis() %>"></script>
    <script>
	    var errMsg = "${error}";
	    if (errMsg) {
	        Swal.fire({
	            icon: 'error',
	            title: 'ขออภัย',
	            text: errMsg,
	            confirmButtonText: 'ตกลง',
	            confirmButtonColor: '#3085d6'
	        });
	    }
	</script>
</body>
</html>