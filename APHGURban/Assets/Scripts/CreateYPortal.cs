using UnityEngine;
using System.Collections;

public class CreateYPortal : MonoBehaviour {

	public GameObject PortalY;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	public void OnTriggerEnter( Collider col)
	{
		Vector3 impactPos = this.transform.position + new Vector3(0, 3, 0);
		PortalY.transform.position = impactPos;
		
	}
}

