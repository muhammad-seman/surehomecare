import { ReactNode } from "react"
import { v4 } from "uuid"

interface DataTableProps {
  columns: string[]
  children: ReactNode
}
function DataTable({ columns, children }: DataTableProps) {
  return (
    <div className="bg-white shadow-lg border-l-4 border-l-primary">
      <table className="w-full data">
        <thead>
          <tr>
            {columns.map((col) => {
              const key = v4()
              return (
                <th key={key} className="text-white bg-primary text-left">
                  {col}
                </th>
              )
            })}
          </tr>
        </thead>
        <tbody className="[&>*:nth-child(even)>td]:bg-primary/10">
          {children}
        </tbody>
      </table>
    </div>
  )
}

export default DataTable