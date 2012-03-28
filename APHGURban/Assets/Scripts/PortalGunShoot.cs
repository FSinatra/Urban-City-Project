using UnityEngine;
using System.Collections;

public class PortalGunShoot : MonoBehaviour {
	public Transform PortalBulletBlue;
	public Transform PortalBulletYellow;
	public GameObject PortalGun;
	public float force = 2000;
	public GameObject BulletSpawn;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	if (Input.GetKeyDown(KeyCode.Mouse0) == true)
		{
			Transform bullet; 
			bullet = (Transform)Instantiate(PortalBulletBlue.transform, PortalGun.transform.position, BulletSpawn.transform.rotation);
			bullet.rigidbody.AddForce(bullet.transform.forward * force);
		}
	else if (Input.GetKeyDown(KeyCode.Mouse1) == true)
		{
			Transform bullet; 
			bullet = (Transform)Instantiate(PortalBulletYellow.transform, PortalGun.transform.position, BulletSpawn.transform.rotation);
			bullet.rigidbody.AddForce(bullet.transform.forward * force);
		}
	}
}