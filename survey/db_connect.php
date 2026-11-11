<?php 

$host = getenv('DB_HOST') ?: '127.0.0.1';
$user = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '';
$dbname = getenv('DB_NAME') ?: 'survey_db';
$port = getenv('DB_PORT') ? (int)getenv('DB_PORT') : 3306;

// Suppress uncaught mysqli_sql_exception on PHP 8.1+ for legacy code compatibility
mysqli_report(MYSQLI_REPORT_OFF);

$conn = @new mysqli($host, $user, $password, $dbname, $port);

// Automatic fallback to embedded local MariaDB if external DB connection fails
if ($conn->connect_error && $host !== '127.0.0.1' && $host !== 'localhost') {
    error_log("Primary DB connection to {$host} failed ({$conn->connect_error}). Falling back to embedded MariaDB.");
    $fallback_conn = @new mysqli('127.0.0.1', 'root', '', $dbname, 3306);
    if (!$fallback_conn->connect_error) {
        $conn = $fallback_conn;
    }
}

if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}
