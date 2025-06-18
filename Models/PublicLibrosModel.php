<?php
class PublicLibrosModel extends Query
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getLibros($title = '', $author = '', $dewey = '', $page = 1, $per_page = 12)
    {
        try {
            $offset = ($page - 1) * $per_page;
            $where = [];
            $params = [];

            // Condición base para libros activos
            $where[] = "estado = 1";

            if (!empty($title)) {
                $where[] = "titulo LIKE '%" . $this->escapeString($title) . "%'";
            }

            if (!empty($author)) {
                $where[] = "autor_personal LIKE '%" . $this->escapeString($author) . "%'";
            }

            if (!empty($dewey)) {
                $where[] = "codigo_dewey LIKE '" . $this->escapeString($dewey) . "%'";
            }

            $whereClause = "WHERE " . implode(" AND ", $where);

            // Consulta para obtener el total de registros
            $totalQuery = "SELECT COUNT(*) as total FROM libro $whereClause";
            error_log("Total query: " . $totalQuery);
            
            $totalResult = $this->select($totalQuery);
            error_log("Total result: " . print_r($totalResult, true));

            if (empty($totalResult) || !isset($totalResult['total'])) {
                error_log("No se encontraron resultados en la consulta de conteo o formato inválido");
                return [
                    'libros' => [],
                    'total_pages' => 0
                ];
            }

            // Corregir el acceso al resultado del conteo
            $total = (int)$totalResult['total'];
            error_log("Total de registros: " . $total);

            if ($total == 0) {
                return [
                    'libros' => [],
                    'total_pages' => 0
                ];
            }

            // Consulta principal con paginación
            $query = "SELECT * FROM libro $whereClause ORDER BY titulo LIMIT $offset, $per_page";
            error_log("Main query: " . $query);

            $libros = $this->selectAll($query);
            error_log("Libros encontrados: " . print_r($libros, true));

            $total_pages = ceil($total / $per_page);

            return [
                'libros' => $libros,
                'total_pages' => $total_pages
            ];
        } catch (Exception $e) {
            error_log("Error en getLibros: " . $e->getMessage());
            error_log("Stack trace: " . $e->getTraceAsString());
            return [
                'libros' => [],
                'total_pages' => 0
            ];
        }
    }

    private function escapeString($string)
    {
        return str_replace(
            ['\\', "\0", "\n", "\r", "'", '"', "\x1a"],
            ['\\\\', '\\0', '\\n', '\\r', "\\'", '\\"', '\\Z'],
            $string
        );
    }

    public function getMaterias()
    {
        try {
            $query = "SELECT * FROM materia WHERE estado = 1 ORDER BY nombre";
            return $this->selectAll($query);
        } catch (Exception $e) {
            error_log("Error en getMaterias: " . $e->getMessage());
            return [];
        }
    }
}