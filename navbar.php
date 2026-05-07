<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Management System</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>

<?php
// Protect every page that includes navbar
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit;
}
?>

<nav class="navbar navbar-expand-lg navbar-dark bank-navbar">
    <div class="container">

        <a class="navbar-brand" href="dashboard.php">
            <svg xmlns="http://www.w3.org/2000/svg"
                 width="22"
                 height="22"
                 fill="currentColor"
                 class="bi bi-bank me-2"
                 viewBox="0 0 16 16"
                 style="vertical-align:text-bottom;">

              <path d="m8 0 6.61 3h.89a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5H15v7a.5.5 0 0 1 .485.38l.5 2a.498.498 0 0 1-.485.62H.5a.498.498 0 0 1-.485-.62l.5-2A.501.501 0 0 1 1 13V6H.5a.5.5 0 0 1-.5-.5v-2A.5.5 0 0 1 .5 3h.89L8 0zM3.777 3h8.447L8 1 3.777 3zM2 6v7h1V6H2zm2 0v7h2.5V6H4zm3.5 0v7h1V6h-1zm2 0v7H12V6H9.5zM13 6v7h1V6h-1zm2-1V4H1v1h14zm-.39 9H1.39l-.25 1h13.72l-.25-1z"/>
            </svg>

            Bank Management
        </a>

        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav">

            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">

            <div class="navbar-nav align-items-center">

                <a class="nav-link" href="dashboard.php">
                    Dashboard
                </a>

                <a class="nav-link" href="customers.php">
                    Customers
                </a>

                <a class="nav-link" href="accounts.php">
                    Accounts
                </a>

                <a class="nav-link" href="transactions.php">
                    Transactions
                </a>

                <!-- NEW EMPLOYEE PAGE -->
                <a class="nav-link" href="employees.php">
                    Employees
                </a>

                <a class="btn btn-logout ms-3" href="logout.php">
                    Logout
                </a>

            </div>
        </div>
    </div>
</nav>
