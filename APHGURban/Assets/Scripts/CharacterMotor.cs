using UnityEngine;
using System.Collections;

public class CharacterMotor : MonoBehaviour {
	
	public float speed = 6.0F;
	public Vector3 moveDirection = Vector3.zero;
	public float jumpHeight = 8.0F;
	public float gravity = 20.0F;
	public GameObject mainCam;
	public float sensitivity = 5.0F;
	public float sprintSpeed = 12.0F;
	public GameObject GunLight;
	
	// Use this for initialization
	void Start () {
	Screen.showCursor = false;
	GunLight.active = false;
	}
	
	// Update is called once per frame
	void Update () {
		CharacterController mainPerson = GetComponent<CharacterController>();
		moveDirection = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
		moveDirection = transform.TransformDirection(moveDirection);
		if (Input.GetKey(KeyCode.LeftShift) == true)
		{
			moveDirection = moveDirection * sprintSpeed;
		}
		else
		{
		moveDirection = moveDirection * speed;
		}
		if (Input.GetKeyDown(KeyCode.Space) == true)
		{
			moveDirection.y = jumpHeight;
		}
		if (Input.GetKeyDown(KeyCode.F) == true)
		{
			if (GunLight.active == false)
			{
			GunLight.active = true;	
			}
			else
			{
			GunLight.active = false; 	
			}
		}
		moveDirection.y = moveDirection.y - gravity * Time.deltaTime;
		mainPerson.Move(moveDirection * Time.deltaTime);
		
		float horizontalRotate = Input.GetAxis("Mouse X") * sensitivity;
		float verticalRotate = Input.GetAxis("Mouse Y") * sensitivity;
		this.transform.Rotate(0, horizontalRotate, 0);
		mainCam.transform.Rotate(-verticalRotate, 0, 0);
	}
	
	
}
