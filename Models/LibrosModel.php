<?php
class LibrosModel extends Query
{
    public function __construct()
    {
        parent::__construct();
    }
    public function getLibros()
    {
        $sql = "SELECT id, codigo_libro, codigo_dewey, titulo, autor_personal, autor_corporativo, cantidad, 
                editorial, lugar, anio_edicion, num_pagina, ubicacion, descripcion, 
                imagen, materia, estado 
                FROM libro";
        // Debug the SQL query
        error_log('SQL Query: ' . $sql);
        $res = $this->selectAll($sql);
        // Debug the results
        error_log('Query Results: ' . print_r($res, true));
        return $res;
    }
    public function insertarLibros($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $imgNombre)
    {
        $verificar = "SELECT * FROM libro WHERE titulo = '$titulo'";
        $existe = $this->select($verificar);
        if (empty($existe)) {
            $query = "INSERT INTO libro(titulo, autor_personal, autor_corporativo, editorial, materia, cantidad, num_pagina, anio_edicion, descripcion, codigo_dewey, codigo_libro, ubicacion, lugar, imagen) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            $datos = array($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $imgNombre);
            $data = $this->save($query, $datos);
            if ($data == 1) {
                $res = "ok";
            } else {
                $res = "error";
            }
        } else {
            $res = "existe";
        }
        return $res;
    }
    public function editLibros($id)
    {
        $sql = "SELECT * FROM libro WHERE id = $id";
        $res = $this->select($sql);
        return $res;
    }
    public function actualizarLibros($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $imgNombre, $id)
    {
        $query = "UPDATE libro SET titulo = ?, autor_personal = ?, autor_corporativo = ?, editorial = ?, materia = ?, cantidad = ?, num_pagina = ?, anio_edicion = ?, descripcion = ?, codigo_dewey = ?, codigo_libro = ?, ubicacion = ?, lugar = ?, imagen = ? WHERE id = ?";
        $datos = array($titulo, $autor_personal, $autor_corporativo, $editorial, $materia, $cantidad, $num_pagina, $anio_edicion, $descripcion, $codigo_dewey, $codigo_libro, $ubicacion, $lugar, $imgNombre, $id);
        $data = $this->save($query, $datos);
        if ($data == 1) {
            $res = "modificado";
        } else {
            $res = "error";
        }
        return $res;
    }
    public function estadoLibros($estado, $id)
    {
        $query = "UPDATE libro SET estado = ? WHERE id = ?";
        $datos = array($estado, $id);
        $data = $this->save($query, $datos);
        return $data;
    }
    public function buscarLibro($valor)
    {
        $sql = "SELECT id, titulo AS text FROM libro WHERE (titulo LIKE '%" . $valor . "%' OR autor_personal LIKE '%" . $valor . "%' OR autor_corporativo LIKE '%" . $valor . "%') AND estado = 1 LIMIT 10";
        $data = $this->selectAll($sql);
        return $data;
    }
    public function verificarPermisos($id_user, $permiso)
    {
        $tiene = false;
        $sql = "SELECT p.*, d.* FROM permisos p INNER JOIN detalle_permisos d ON p.id = d.id_permiso WHERE d.id_usuario = $id_user AND p.nombre = '$permiso'";
        $existe = $this->select($sql);
        if ($existe != null || $existe != "") {
            $tiene = true;
        }
        return $tiene;
    }
    public function getTotalLibrosDisponibles()
    {
        $sql = "SELECT SUM(cantidad) as total FROM libro";
        $data = $this->select($sql);
        return $data['total'] ?? 0;
    }
    public function selectDatos()
    {
        $sql = "SELECT * FROM configuracion";
        return $this->select($sql);
    }
}
