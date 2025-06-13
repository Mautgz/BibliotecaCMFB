<?php
class HomeModel{
    public function __construct()
    {
        
    }

    public function getConsultasFrecuentes()
    {
        $conexion = new Conexion();
        $sql = "SELECT mensaje as consulta, COUNT(*) as frecuencia, 
                MAX(fecha_hora) as ultima_consulta 
                FROM chatbot_logs 
                GROUP BY mensaje 
                ORDER BY frecuencia DESC 
                LIMIT 10";
        $data = $conexion->query($sql);
        return $data;
    }
}

?>