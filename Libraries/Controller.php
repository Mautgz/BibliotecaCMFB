<?php

class Controller
{
    protected $views;

    public function __construct()
    {
        $this->views = new Views(); // Assuming Views class is in Libraries or autoloaded
        session_start(); // Start session when controller is instantiated
    }

    public function loadModel($modelName)
    {
        $modelPath = ROOT . 'Models/' . $modelName . 'Model.php';

        if (file_exists($modelPath)) {
            $modelClassName = $modelName . 'Model';
            // Check if the class exists before instantiating
            if (class_exists($modelClassName)) {
                 return new $modelClassName();
            } else {
                 error_log("Model class '" . $modelClassName . "' not found in file " . $modelPath);
                 return null;
            }
        } else {
            error_log("Model file not found: " . $modelPath);
            return null;
        }
    }
} 