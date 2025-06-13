<?php

class Query extends Conexion
{
    private $pdo, $con;

    public function __construct()
    {
        $this->con = new Conexion(); // Assuming Conexion class is in Libraries or autoloaded
        $this->pdo = $this->con->conect();
    }

    // Select a single row
    public function select(string $sql, array $params = [])
    {
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Select multiple rows
    public function selectAll(string $sql, array $params = [])
    {
         $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Insert or Update (Save)
    public function save(string $sql, array $params = [])
    {
         $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount(); // Return number of affected rows
    }
} 