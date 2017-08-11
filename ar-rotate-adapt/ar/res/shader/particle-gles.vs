/*
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 * (C) COPYRIGHT 2013 ARM Limited
 * ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 */

/* [Vertex Shader] */
attribute vec3 position;
attribute vec3 velocity;
attribute vec3 particleTimes;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

uniform vec3 gravity;
uniform vec3 colour;
uniform float particleSize;

varying float v_ageFactor;
varying vec3 v_v3colour;

void main()
{
    vec3 newPos;
    float ageFactor;
    float delay    = particleTimes.x;
    float lifetime = particleTimes.y;
    float age      = particleTimes.z;
    
    if( age  > delay )
    {
        float t = age - delay;
        /* Particle motion equation. */
        //newPos = position + velocity * t + 0.5 * gravity * t * t;
        newPos = position + velocity * t + 0.5 * -0.06 * t * t;
        
        ageFactor = 1.0 - (age / lifetime);
        ageFactor = clamp(ageFactor, 0.0, 1.0);

        /* The older the particle the smaller its size. */
        gl_PointSize = ageFactor * particleSize;
    }
    else
    {
        newPos = position;
        /* If null size particle will not be drawn. */
        gl_PointSize = 0.0;
        ageFactor = 0.0;
    }

    /* Initializing varying. */
    v_ageFactor = ageFactor;
    v_v3colour = colour;
    //v_v3colour = vec3(0.9, 0.9, 0.9);
    
    /* Particle position. */
    gl_Position.xyz = newPos;
    gl_Position.w = 1.0;

    /* Apply matrix transformation. */
    gl_Position = Proj * View * World * gl_Position;
}
/* [Vertex Shader] */
