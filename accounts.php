<?php
session_start();
include("db.php");
?>
<?php include("navbar.php"); ?>

<div class="container mt-5">
    <h2 class="mb-4" style="font-weight: 700; color: var(--primary-dark);">Account Directory</h2>

    <div class="bank-table-wrapper">
        <table class="table bank-table table-hover table-borderless">
            <thead>
                <tr>
                    <th>Account No</th>
                    <th>Customer Name</th>
                    <th>Branch</th>
                    <th>Type</th>
                    <th>Balance</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <?php
            $result = $conn->query("
                SELECT A.*, C.Name AS Customer_Name, B.Branch_Name
                FROM ACCOUNT A
                JOIN CUSTOMER C ON A.Customer_ID = C.Customer_ID
                JOIN BRANCH B ON A.Branch_ID = B.Branch_ID
                ORDER BY A.Account_No
            ");
            if ($result->num_rows === 0) {
                echo "<tr><td colspan='6' class='text-center text-muted py-4'>No accounts found.</td></tr>";
            }
            while ($row = $result->fetch_assoc()) {
                $statusBadge = match($row['Status']) {
                    'Active'   => 'bg-success',
                    'Inactive' => 'bg-warning text-dark',
                    'Closed'   => 'bg-danger',
                    default    => 'bg-secondary'
                };
                echo "<tr>";
                echo "<td><strong class='text-primary'>#" . $row['Account_No'] . "</strong></td>";
                echo "<td><span class='fw-bold'>" . htmlspecialchars($row['Customer_Name']) . "</span></td>";
                echo "<td>" . htmlspecialchars($row['Branch_Name']) . "</td>";
                echo "<td><span class='badge bg-secondary bg-opacity-75'>" . htmlspecialchars($row['Account_Type']) . "</span></td>";
                echo "<td><strong>₹" . number_format($row['Balance'], 2) . "</strong></td>";
                echo "<td><span class='badge rounded-pill $statusBadge'>" . $row['Status'] . "</span></td>";
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
