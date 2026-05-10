<?php
session_start();
include("db.php");
include("navbar.php");
?>

<div class="container mt-5">

    <h2 class="mb-4"
        style="font-weight:700; color: var(--primary-dark);">
        Employee Management
    </h2>

    <!-- STAT CARDS -->
     <div class="row g-4 mb-4">

        <!-- Total Employee -->
        <div class="col md-4">
            <div class="stat-card stat-primary">
                <h4>Total Employees</h4>

                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(*) as total FROM EMPLOYEE");
                    $row =$q->fetch_assoc();
                    echo $row['total'];
                    ?>
                    </div>
                </div>
            </div>

    <!-- Total salary -->
    <div class="col-md-4">
        <div class="stat-card stat-success">
            <h4>Total Salary</h4>

            <div class="value">
                <?php
                $q = $conn->query("SELECT SUM(Salary) as total FROM EMPLOYEE");
                $row = $q->fetch_assoc();

                echo "₹" . number_format($row['total'],0);
                ?>
                </div>
            </div>
        </div>

        <!-- Branches Covered -->
        <div class="col-md-4">
            <div class="stat-card stat-warning">
                <h4>Branches Covered</h4>

                <div class="value">
                    <?php
                    $q = $conn->query("SELECT COUNT(DISTINCT Branch_ID) as total FROM EMPLOYEE");
                    $row = $q->fetch_assoc();

                    echo $row['total'];
                    ?>
                    </div>
                </div>
            </div>

    </div>

    <!--EMPLOYEE TABLE -->
    <div class="bank-table-wrapper">

        <table class="table bank-table table-hover table-borderless">

            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Branch ID</th>
                    <th>Name</th>
                    <th>Designation</th>
                    <th>Salary</th>
                    <th>Join Date</th>
                </tr>
            </thead>

            <tbody>

                <?php

                $result = $conn->query("SELECT * FROM EMPLOYEE ORDER BY Employee_ID ASC");

                if($result && $result->num_rows > 0){

                    while($row = $result->fetch_assoc()){

                        echo"<tr>";

                        echo "<td>
                                <strong class='text-primary'>
                                #" . $row['Employee_ID'] , "
                                </strong>
                                </td>";

                        echo "<td>" . $row['Brach_ID'] . "</td>";

                        echo "<td>" . $row['Name'] , "</td>";

                        echo "<td>
                                <span class='badge bg-info'>
                                " , $row['Designation'] ,"
                                </span>
                                </td>";

                        echo "<td>
                                ₹" , number_format($row['Salary'],2) , "
                                </td>";

                        echo "<td>" ,
                                date('d M Y', strtotime($row['Join_Date']))
                                , "</td>";

                        echo "</tr>";
                    }

                } else {

                echo "
                <tr>
                    <td colspan='6' class='text-center text-muted'>
                        No employee records found
                    </td>
                </tr>
                ";
                }

                ?>

            </tbody>

        </table>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
