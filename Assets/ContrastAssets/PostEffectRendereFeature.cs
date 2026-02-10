using UnityEngine;
using UnityEngine.Rendering.Universal;

public class PostEffectRenderFeature : ScriptableRendererFeature
{
    [SerializeField] Material postEffectMaterial_;
    private PostEffectRenderPass renderPass_;

    public override void Create()
    {
        renderPass_ = new PostEffectRenderPass(postEffectMaterial_);

        // ƒJƒƒ‰Color“ü—Í‚ğ—LŒø‚É‚·‚é
        renderPass_.renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
    }

    public override void AddRenderPasses(ScriptableRenderer renderePass, ref RenderingData renderingData)
    {
        if (renderePass != null)
        {
            renderePass.EnqueuePass(renderPass_);
        }
    }
}