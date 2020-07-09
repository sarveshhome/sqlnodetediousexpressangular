import { ActivatedRoute, Params } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { EmpService } from 'src/app/emp.service';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-empdetails',
  templateUrl: './empdetails.component.html',
  styleUrls: ['./empdetails.component.css']
})
export class EmpdetailsComponent implements OnInit {

  empno: any;
  empDetailsData:any;
  constructor(private route:ActivatedRoute,private empService: EmpService) { }

  ngOnInit(): void {
    // this.route.params.subscribe(d=>{
    //   console.log(d);
    //     this.empno =d.id;
    // });

    // this.empService.getEmployeeDetails(this.empno).subscribe(
    //   data=>{
    //     this.empDetailsData= data;
    //   }
    // );

    this.route.params.pipe(switchMap((p:Params)=> this.empService.getEmployeeDetails(p['id']))).subscribe(
      data=>{
        this.empDetailsData= data;
        console.log(this.empDetailsData);
        this.empno =this.empDetailsData.empno;
      }
    );

  }

}
