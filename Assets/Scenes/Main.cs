using UnityEngine;
using UnityEngine.UI;

public class Main : MonoBehaviour {

    [SerializeField] Button btn_freeze;
    [SerializeField] Button btn_transition;
    [SerializeField] Shader dissolveShader;

    RenderTexture freezeTexture;
    bool isFrozen = false;
    Material dissolveMaterial;

    void Start() {
        // btn_freeze.onClick.AddListener(() => {
        //     OnFreeze();
        // });

        // btn_transition.onClick.AddListener(() => {
        //     OnTransition();
        // });
        dissolveMaterial = new Material(dissolveShader);
    }

    void OnFreeze() {
        if (freezeTexture != null) {
            RenderTexture.ReleaseTemporary(freezeTexture);
        }
        freezeTexture = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);
        isFrozen = true;

        // 捕获当前画面
        GetComponent<Camera>().targetTexture = freezeTexture;
        GetComponent<Camera>().Render();
        GetComponent<Camera>().targetTexture = null;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        Debug.Log("OnRenderImage called");

        if (isFrozen && freezeTexture != null) {
            Graphics.Blit(src, freezeTexture);
            isFrozen = false;
        }

        if (freezeTexture != null) {
            dissolveMaterial.SetTexture("_MainTex", freezeTexture);
            Graphics.Blit(freezeTexture, dest, dissolveMaterial);
            Debug.Log("Blit with dissolve shader");
        } else {
            Graphics.Blit(src, dest);
            Debug.Log("Normal blit");
        }
    }

    void OnTransition() {
    }

    void Update() {
        if (Input.GetKeyDown(KeyCode.Space)) {
            OnFreeze();
            Debug.Log("Freeze");
        }
    }

}