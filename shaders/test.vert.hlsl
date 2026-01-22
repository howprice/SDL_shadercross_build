// Adapted from https://github.com/TheSpydog/SDL_gpu_examples

struct Input
{
    uint VertexID : SV_VertexID;
};

struct Output
{
    float4 Position : SV_Position;
    float4 Color : TEXCOORD0;
};

Output main(Input input)
{
    Output output;
    float2 pos;
    if (input.VertexID == 0)
    {
        pos = (-1.0f).xx;
        output.Color = float4(1.0f, 0.0f, 0.0f, 1.0f);
    }
    else if (input.VertexID == 1)
    {
        pos = float2(1.0f, -1.0f);
        output.Color = float4(0.0f, 1.0f, 0.0f, 1.0f);
    }
    else // if (input.VertexID == 2)
    {
        pos = float2(0.0f, 1.0f);
        output.Color = float4(0.0f, 0.0f, 1.0f, 1.0f);
    }
    output.Position = float4(pos, 0.0f, 1.0f);
    return output;
}
