SELECT empno as id
    , ename as name
    , job
    , mgr as manager_id
    , hiredate as hire_dt
    , sal as salary
    , comm as comission
    , deptno as department_id 
FROM emp 
WHERE job='ANALYST'
