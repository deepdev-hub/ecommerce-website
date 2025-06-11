package com.example.ecommerce.model;
import java.time.LocalDate;
import jakarta.persistence.Entity;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
@EqualsAndHashCode(callSuper=false)
@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name="storestaff")
@Inheritance(strategy = InheritanceType.JOINED)
@PrimaryKeyJoinColumn(name = "storestaffid") 

public class StoreStaff extends People  implements HaveSalary{
    private String storestaffusername;
    private String storestaffpassword;
    private String email;
    private String phone;
    private String gender;
    private String position;
    private String address;
    private LocalDate startdate;
    private Integer workhour;
    private Double hesoluong;
    private static double luongcoban = 5000000;
    private static double luongmax = 50000000;
    private static int workhourmax = 22*8;
    @Override
    public double calculateSalary(){
        return (double)this.hesoluong*((double)this.workhour/(double)StoreStaff.workhourmax)*StoreStaff.luongcoban;
    }
    
    @Override
    public boolean increaseSalary(double step){
        if((this.hesoluong+step)*(this.workhour/StoreStaff.workhourmax)*StoreStaff.luongcoban> StoreStaff.luongmax){
            return false;
        }
        this.hesoluong+=step;
        return true;
    }
    
    public static double getLuongcoban() {
    return luongcoban;
}
    
    @Override
    public boolean decreaseSalary(double step){
        if((this.hesoluong-step)*(this.workhour/StoreStaff.workhourmax)*StoreStaff.luongcoban< 0){
            return false;
        }
        this.hesoluong-=step;
        return true;
    }
    
    
    
}