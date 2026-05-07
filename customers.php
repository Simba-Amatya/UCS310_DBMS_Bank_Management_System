<?php
session_start();
include("db.php");
?>
<?php include("navbar.php"); ?>

<div class="container mt-5">
    <h2 class="mb-4" style="font-weight: 700; color: var(--primary-dark);">Customer Directory</h2>

    <div class="bank-table-wrapper">
        <table class="table bank-table table-hover table-borderless">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>City</th>
                    <th>State</th>
                </tr>
            </thead>
            <tbody>
            <?php
            $result = $conn->query("SELECT * FROM CUSTOMER ORDER BY Customer_ID");
            if ($result->num_rows === 0) {
                echo "<tr><td colspan='6' class='text-center text-muted py-4'>No customers found.</td></tr>";
            }
            while ($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td><strong class='text-primary'>#" . $row['Customer_ID'] . "</strong></td>";
                echo "<td><span class='fw-bold'>" . htmlspecialchars($row['Name']) . "</span></td>";
                echo "<td>" . htmlspecialchars($row['Phone_No']) . "</td>";
                echo "<td><span class='text-muted'>" . htmlspecialchars($row['Email'] ?? '—') . "</span></td>";
                echo "<td>" . htmlspecialchars($row['City'] ?? '—') . "</td>";
                echo "<td>" . htmlspecialchars($row['State'] ?? '—') . "</td>";
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
