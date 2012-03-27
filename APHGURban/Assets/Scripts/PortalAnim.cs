using UnityEngine;
using System.Collections;


public class PortalAnim : MonoBehaviour {


	
	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
	if (Input.GetKey(KeyCode.W) == true)
		{
			animation.Play("PortalGunBob");
			
		}
 	else 
		{
			animation.Stop("PortalGunBob");
			animation.Play("PortalGunIdle");	
		}
			
	
	}
}
