import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, throwError } from 'rxjs';
import { catchError, map, tap} from 'rxjs/operators';


@Injectable({
  providedIn: 'root'
})
export class EmpService {
  apiurl ='http://localhost:8091/api/employees';
  headers = new HttpHeaders()
            .set('content-Type','application/json')
            .set('Accept','application/json');

  httpOptions ={
    headers: this.headers
  }


  constructor(private http: HttpClient) { }
   getEmployees():Observable<any>{
     return this.http.get<any>(this.apiurl,this.httpOptions).pipe(
       tap(data=>{console.log(data)}),
       catchError(this.handleError)
     )
   }
   private handleError(error:any){
      console.error(error);
      return throwError(error);
   }
}
