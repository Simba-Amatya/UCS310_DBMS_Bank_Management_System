<?php
session_start();
include("db.php");
?>
<?php include("navbar.php"); ?>

<div class="container mt-5">
    <h2 class="mb-4" style="font-weight: 700; color: var(--primary-dark);">System Dashboard</h2>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="stat-card stat-primary">
                <h4>Total Customers</h4>
                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(*) as total FROM CUSTOMER");
                    echo $q->fetch_assoc()['total'];
                    ?>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card stat-success">
                <h4>Total Accounts</h4>
                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(*) as total FROM ACCOUNT");
                    echo $q->fetch_assoc()['total'];
                    ?>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card stat-warning">
                <h4>Active Loans</h4>
                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(*) as total FROM LOAN WHERE Status='Approved'");
                    echo $q->fetch_assoc()['total'];
                    ?>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mt-2">
        <div class="col-md-4">
            <div class="stat-card" style="background: linear-gradient(135deg,#8b5cf6,#6d28d9);">
                <h4>Total Balance</h4>
                <div class="value" style="font-size:1.6rem;">
                    <?php
                    $q = $conn->query("SELECT SUM(Balance) as total FROM ACCOUNT WHERE Status='Active'");
                    $val = $q->fetch_assoc()['total'];
                    echo "₹" . number_format($val, 0);
                    ?>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card" style="background: linear-gradient(135deg,#0ea5e9,#0284c7);">
                <h4>Transactions</h4>
                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(*) as total FROM TRANSACTION_LOG");
                    echo $q->fetch_assoc()['total'];
                    ?>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card" style="background: linear-gradient(135deg,#f43f5e,#e11d48);">
                <h4>Employees</h4>
                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(*) as total FROM EMPLOYEE");
                    echo $q->fetch_assoc()['total'];
                    ?>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Transactions -->
    <div class="mt-5">
        <h5 class="mb-3" style="font-weight:700; color:var(--primary-dark);">Recent Transactions</h5>
        <div class="bank-table-wrapper">
            <table class="table bank-table table-hover table-borderless">
                <thead>
                    <tr>
                        <th>Txn ID</th>
                        <th>Account No</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <?php
                $result = $conn->query("SELECT * FROM TRANSACTION_LOG ORDER BY Txn_Date DESC LIMIT 5");
                while ($row = $result->fetch_assoc()) {
                    $isCredit = in_array($row['Txn_Type'], ['Deposit', 'Transfer In']);
                    $amtClass = $isCredit ? 'text-success' : 'text-danger';
                    $sign     = $isCredit ? '+' : '-';
                    $badge    = $isCredit ? 'bg-success' : 'bg-danger';
                    echo "<tr>";
                    echo "<td><strong class='text-muted'>#" . $row['Transaction_ID'] . "</strong></td>";
                    echo "<td><strong class='text-primary'>#" . $row['Account_No'] . "</strong></td>";
                    echo "<td><span class='badge rounded-pill $badge bg-opacity-75'>" . $row['Txn_Type'] . "</span></td>";
                    echo "<td><span class='fw-bold $amtClass'>$sign ₹" . number_format($row['Amount'], 2) . "</span></td>";
                    echo "<td>" . date('d M Y', strtotime($row['Txn_Date'])) . "</td>";
                    echo "</tr>";
                }
                ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
