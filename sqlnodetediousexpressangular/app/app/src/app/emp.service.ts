import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, throwError } from 'rxjs';
import { catchError, map, tap} from 'rxjs/operators';


@Injectable({
  providedIn: 'root'
})
export class EmpService {
  private static count =0;
  apiurl ='http://localhost:8091/api/employees';
  headers = new HttpHeaders()
            .set('content-Type','application/json')
            .set('Accept','application/json');

  httpOptions ={
    headers: this.headers
  }


  constructor(private http: HttpClient) {
      EmpService.count = EmpService.count +1;
      console.log(EmpService.count);

  }
   getEmployees():Observable<any>{
     return this.http.get<any>(this.apiurl,this.httpOptions).pipe(
       tap(data=>{
         //console.info(data)
        }),
       catchError(this.handleError)
     )
   }

   getEmployeeDetails(id:string):Observable<any>{
     console.log('emp services');
     return this.http.get<any>(this.apiurl+'/'+id).pipe(
      tap(data=>{
        console.info(data)
       }),
      catchError(this.handleError)
     );
   }

   private handleError(error:any){
      console.error(error);
      return throwError(error);
   }
}
