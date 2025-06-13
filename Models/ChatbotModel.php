<?php
class ChatbotModel extends Query
{
    public function __construct()
    {
        parent::__construct();
    }

    public function buscarLibrosRelevantes($query)
    {
        try {
            $query = strtolower($query);
            $sql = "SELECT * FROM libro 
                    WHERE estado = 1 AND (
                        LOWER(titulo) LIKE ? OR 
                        LOWER(autor_personal) LIKE ? OR 
                        LOWER(autor_corporativo) LIKE ? OR 
                        LOWER(editorial) LIKE ? OR 
                        LOWER(descripcion) LIKE ? OR 
                        LOWER(materia) LIKE ?
                    )
                    LIMIT 5";
            
            $searchTerm = "%" . $query . "%";
            $datos = array($searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm);
            
            $data = $this->selectAll($sql, $datos);
            return $data ?: [];
        } catch (Exception $e) {
            error_log("Error in buscarLibrosRelevantes: " . $e->getMessage());
            return [];
        }
    }

    public function getAllLibros()
    {
        try {
            $sql = "SELECT * FROM libro WHERE estado = 1";
            $data = $this->selectAll($sql);
            return $data ?: [];
        } catch (Exception $e) {
            error_log("Error in getAllLibros: " . $e->getMessage());
            return [];
        }
    }
} 