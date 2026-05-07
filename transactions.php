<?php
session_start();
include("db.php");
?>
<?php include("navbar.php"); ?>

<div class="container mt-5">
    <h2 class="mb-4" style="font-weight: 700; color: var(--primary-dark);">Transaction History</h2>

    <div class="bank-table-wrapper">
        <table class="table bank-table table-hover table-borderless">
            <thead>
                <tr>
                    <th>Txn ID</th>
                    <th>Account No</th>
                    <th>Customer</th>
                    <th>Date &amp; Time</th>
                    <th>Amount</th>
                    <th>Type</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
            <?php
            $result = $conn->query("
                SELECT T.*, C.Name AS Customer_Name
                FROM TRANSACTION_LOG T
                JOIN ACCOUNT A ON T.Account_No = A.Account_No
                JOIN CUSTOMER C ON A.Customer_ID = C.Customer_ID
                ORDER BY T.Txn_Date DESC
            ");
            if ($result->num_rows === 0) {
                echo "<tr><td colspan='7' class='text-center text-muted py-4'>No transactions found.</td></tr>";
            }
            while ($row = $result->fetch_assoc()) {
                $isCredit  = in_array($row['Txn_Type'], ['Deposit', 'Transfer In']);
                $amtClass  = $isCredit ? 'text-success' : 'text-danger';
                $sign      = $isCredit ? '+' : '-';
                $badge     = $isCredit ? 'bg-success' : 'bg-danger';

                echo "<tr>";
                echo "<td><strong class='text-muted'>#" . $row['Transaction_ID'] . "</strong></td>";
                echo "<td><strong class='text-primary'>#" . $row['Account_No'] . "</strong></td>";
                echo "<td>" . htmlspecialchars($row['Customer_Name']) . "</td>";
                echo "<td>" . date('d M Y, h:i A', strtotime($row['Txn_Date'])) . "</td>";
                echo "<td><span class='fw-bold $amtClass'>$sign ₹" . number_format($row['Amount'], 2) . "</span></td>";
                echo "<td><span class='badge rounded-pill $badge bg-opacity-75'>" . $row['Txn_Type'] . "</span></td>";
                echo "<td class='text-muted'>" . htmlspecialchars($row['Description'] ?? '—') . "</td>";
                echo "</tr>";
            }
            ?>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
