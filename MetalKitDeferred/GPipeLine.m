//
//  GPipeLine.m
//  MetalKitDeferredLighting
//
//  Created by Bogdan Adam on 12/1/15.
//  Copyright © 2015 Bogdan Adam. All rights reserved.
//

#import "GPipeLine.h"

@implementation GPipeLine
{
    id <MTLRenderPipelineState> _pipelineState;
}

- (id)initWithDevice:(id<MTLDevice>)_device library:(id <MTLLibrary>)_library
{
    self = [super init];
    if (self)
    {
        id <MTLFunction> fragmentProgram = [_library newFunctionWithName:@"gBufferFrag"];
        if(!fragmentProgram)
            NSLog(@">> ERROR: Couldn't load fragment function from default library");
        
        id <MTLFunction> vertexProgram = [_library newFunctionWithName:@"gBufferVert"];
        if(!vertexProgram)
            NSLog(@">> ERROR: Couldn't load vertex function from default library");
        
        
        MTLVertexDescriptor *mtlVertexDescriptor = [[MTLVertexDescriptor alloc] init];
        
        // Positions.
        mtlVertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        mtlVertexDescriptor.attributes[0].offset = 0;
        mtlVertexDescriptor.attributes[0].bufferIndex = 0;
        
        // Normals.
        mtlVertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
        mtlVertexDescriptor.attributes[1].offset = 12;
        mtlVertexDescriptor.attributes[1].bufferIndex = 0;
        
        // Texture coordinates.
        mtlVertexDescriptor.attributes[2].format = MTLVertexFormatHalf2;
        mtlVertexDescriptor.attributes[2].offset = 24;
        mtlVertexDescriptor.attributes[2].bufferIndex = 0;
        
        // Single interleaved buffer.
        mtlVertexDescriptor.layouts[0].stride = 32;
        mtlVertexDescriptor.layouts[0].stepRate = 1;
        mtlVertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunctionPerVertex;
        
        
        
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        
        pipelineStateDescriptor.label                           = @"gPipeline";
        pipelineStateDescriptor.sampleCount                     = 1;
        pipelineStateDescriptor.vertexFunction                  = vertexProgram;
        pipelineStateDescriptor.fragmentFunction                = fragmentProgram;
        pipelineStateDescriptor.vertexDescriptor                = mtlVertexDescriptor;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatRGBA8Unorm;
        pipelineStateDescriptor.colorAttachments[1].pixelFormat = MTLPixelFormatRGBA16Float;
        pipelineStateDescriptor.depthAttachmentPixelFormat      = MTLPixelFormatDepth32Float;
        
        NSError *error = nil;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        if(!_pipelineState) {
            NSLog(@">> ERROR: Failed Aquiring pipeline state: %@", error);
        }
    }
    return self;
}

- (id <MTLRenderPipelineState>)_pipeline
{
    return _pipelineState;
}

@end
