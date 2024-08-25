using UnityEngine;

public class RoleEntity : MonoBehaviour {

    public float speed = 1.0f;
    public Vector2[] path;
    public int pathIndex = 0;

    public void Update() {
        var dt = Time.deltaTime;
        AutoMoveByPath(dt);
    }

    void AutoMoveByPath(float dt) {
        if (path == null || path.Length == 0) {
            return;
        }

        if (pathIndex >= path.Length) {
            pathIndex = 0;
        }

        Vector2 dir = path[pathIndex] - (Vector2)transform.position;
        if (dir.magnitude < 0.1f) {
            pathIndex++;
            return;
        }

        dir.Normalize();
        Move(dir, speed, dt);
    }

    void Move(Vector2 dir, float speed, float dt) {
        transform.position += new Vector3(dir.x, dir.y, 0) * speed * dt;
    }

    void OnDrawGizmos() {
        if (path == null || path.Length == 0) {
            return;
        }

        Gizmos.color = Color.red;
        for (int i = 0; i < path.Length - 1; i++) {
            Gizmos.DrawCube(path[i], Vector3.one * 0.1f);
            Gizmos.DrawLine(path[i], path[i + 1]);
        }
        Gizmos.DrawCube(path[path.Length - 1], Vector3.one * 0.1f);
        Gizmos.DrawLine(path[path.Length - 1], path[0]);
    }

}