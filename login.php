<?php
session_start();

$error = "";

if (isset($_POST['login'])) {
    $user = $_POST['username'];
    $pass = $_POST['password'];

    // Simple hardcoded credentials (no ADMIN table needed)
    if ($user === "admin" && $pass === "admin123") {
        $_SESSION['admin'] = $user;
        header("Location: dashboard.php");
        exit;
    } else {
        $error = "Invalid Admin Credentials";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Login - Bank System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="login-body">

    <div class="login-card">
        <div class="brand-logo">B</div>
        <h3 class="text-center mb-1" style="font-weight: 700;">Admin Portal</h3>
        <p class="text-center text-muted mb-4" style="font-size:0.85rem;">Bank Management System</p>

        <?php if ($error != ""): ?>
            <div class="alert alert-danger" role="alert"><?php echo $error; ?></div>
        <?php endif; ?>

        <form method="post">
            <div class="mb-3">
                <label class="form-label text-muted small fw-bold text-uppercase">Username</label>
                <input class="form-control p-3" name="username" placeholder="Enter administrator ID" required>
            </div>
            <div class="mb-4">
                <label class="form-label text-muted small fw-bold text-uppercase">Password</label>
                <input class="form-control p-3" type="password" name="password" placeholder="Enter password" required>
            </div>
            <button class="btn btn-bank-primary w-100 p-3" name="login">Secure Login</button>
        </form>

        <div class="mt-3 text-center text-muted" style="font-size:0.8rem;">
            Demo: <strong>admin</strong> / <strong>admin123</strong>
        </div>
    </div>

</body>
</html>
