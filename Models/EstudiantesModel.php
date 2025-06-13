<?php
class EstudiantesModel extends Query{
    public function __construct()
    {
        parent::__construct();
    }
    public function getEstudiantes()
    {
        $sql = "SELECT * FROM estudiante";
        $res = $this->selectAll($sql);
        return $res;
    }
    public function verificarDni($dni)
    {
        $verificar = "SELECT * FROM estudiante WHERE dni = '$dni'";
        $existe = $this->select($verificar);
        return $existe;
    }
    public function insertarEstudiante($codigo, $dni, $nombre, $año, $direccion, $telefono)
    {
        $verificar = "SELECT * FROM estudiante WHERE codigo = '$codigo'";
        $existe = $this->select($verificar);
        if (empty($existe)) {
            // Verificar DNI duplicado
            $verificarDni = $this->verificarDni($dni);
            if (!empty($verificarDni)) {
                return "dni_existe";
            }
            $query = "INSERT INTO estudiante(codigo,dni,nombre,año,direccion,telefono) VALUES (?,?,?,?,?,?)";
            $datos = array($codigo, $dni, $nombre, $año, $direccion, $telefono);
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
    public function editEstudiante($id)
    {
        $sql = "SELECT * FROM estudiante WHERE id = $id";
        $res = $this->select($sql);
        return $res;
    }
    public function actualizarEstudiante($codigo, $dni, $nombre, $año, $direccion, $telefono, $id)
    {
        $query = "UPDATE estudiante SET codigo = ?, dni = ?, nombre = ?, año = ?, direccion = ?, telefono = ? WHERE id = ?";
        $datos = array($codigo, $dni, $nombre, $año, $direccion, $telefono, $id);
        $data = $this->save($query, $datos);
        if ($data == 1) {
            $res = "modificado";
        } else {
            $res = "error";
        }
        return $res;
    }
    public function estadoEstudiante($estado, $id)
    {
        $query = "UPDATE estudiante SET estado = ? WHERE id = ?";
        $datos = array($estado, $id);
        $data = $this->save($query, $datos);
        return $data;
    }
    public function buscarEstudiante($valor)
    {
        $sql = "SELECT id, codigo, nombre AS text FROM estudiante WHERE (codigo LIKE '%" . $valor . "%' OR nombre LIKE '%" . $valor . "%' OR dni LIKE '%" . $valor . "%') AND estado = 1 LIMIT 10";
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
    public function eliminarDefinitivo($id)
    {
        // Verificar si tiene préstamos
        $sql = "SELECT COUNT(*) as total FROM prestamo WHERE id_estudiante = ?";
        $res = $this->select($sql, [$id]);
        if ($res['total'] > 0) {
            return "con_prestamos";
        }
        // Eliminar definitivamente
        $query = "DELETE FROM estudiante WHERE id = ?";
        $data = $this->save($query, [$id]);
        return $data == 1 ? "ok" : "error";
    }
    public function selectDatos()
    {
        $sql = "SELECT * FROM configuracion";
        return $this->select($sql);
    }
    public function getAlumnos()
    {
        $sql = "SELECT * FROM estudiante";
        return $this->selectAll($sql);
    }
}
