<?php

require_once '../html/hello.php';

class HelloWorldTest extends PHPUnit\Framework\TestCase
{
 public function testOutput()
 {
    // Capture the output of hello.php
    ob_start();
    include '../html/hello.php';
    $output = ob_get_clean();

    // Assert that the output is "Hello, Docker!"
    $this->assertEquals("Hello, Docker!", $output);
 }
}
?>
