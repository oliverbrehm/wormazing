void main(void) {
    vec4 color = SKDefaultShading();
    
    color.x = color.x * (0.8 + (sin(v_tex_coord.x * 20.0) + 1.0) / 5.0);
    color.y = color.y * (0.8 + (sin(v_tex_coord.x * 20.0) + 1.0) / 5.0);
    color.z = color.z * (0.8 + (sin(v_tex_coord.x * 20.0) + 1.0) / 5.0);
    
    color.x = color.x * (0.8 + (sin(v_tex_coord.y * 10.0) + 1.0) / 5.0);
    color.y = color.y * (0.8 + (sin(v_tex_coord.y * 10.0) + 1.0) / 5.0);
    color.z = color.z * (0.8 + (sin(v_tex_coord.y * 10.0) + 1.0) / 5.0);
    
    gl_FragColor = color;
    //gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}