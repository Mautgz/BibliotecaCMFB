<?php
class PublicLibrosModel extends Query
{
    public function getLibros($title = '', $author = '', $dewey = '', $page = 1, $per_page = 12)
    {
        $offset = ($page - 1) * $per_page;
        $where = ['estado = 1'];
        $params = [];

        if (!empty($title)) {
            $where[] = 'titulo LIKE ?';
            $params[] = "%$title%";
        }

        if (!empty($author)) {
            $where[] = 'autor_personal LIKE ?';
            $params[] = "%$author%";
        }

        if ($dewey !== '') {
            $where[] = "LEFT(codigo_dewey, 1) = '" . intval($dewey) . "'";
        }

        $whereClause = implode(' AND ', $where);

        // Obtener total de registros para paginación
        $sqlCount = "SELECT COUNT(*) as total FROM libro WHERE $whereClause";
        $total = $this->select($sqlCount, $params);
        $total_pages = ceil($total['total'] / $per_page);

        // Obtener libros con paginación
        $sql = "SELECT * FROM libro WHERE $whereClause ORDER BY titulo LIMIT $offset, $per_page";

        $libros = $this->selectAll($sql, $params);

        return [
            'libros' => $libros,
            'total_pages' => $total_pages
        ];
    }

    public function getMaterias()
    {
        $sql = "SELECT id, nombre FROM materias WHERE estado = 1 ORDER BY nombre";
        return $this->selectAll($sql);
    }
}